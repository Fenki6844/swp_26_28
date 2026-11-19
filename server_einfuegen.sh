mkdir -p ~/schuelerliste/db ~/schuelerliste/web && cd ~/schuelerliste
cat > docker-compose.yml <<'SCHUELERLISTE_EOF'
services:
  db:
    image: mariadb:11
    container_name: schueler_db
    restart: unless-stopped
    environment:
      MARIADB_ROOT_PASSWORD: "RootPasswort2026!"
    volumes:
      - db_data:/var/lib/mysql
      # Skripte werden beim allerersten Start automatisch ausgeführt
      - ./db:/docker-entrypoint-initdb.d:ro
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      interval: 10s
      timeout: 5s
      retries: 10

  web:
    build: ./web
    container_name: schueler_web
    restart: unless-stopped
    ports:
      - "80:80"
    environment:
      DB_HOST: db
      DB_NAME: schuelerdatenbank
      DB_USER: webuser
      DB_PASS: "Schueler2026!"
    depends_on:
      db:
        condition: service_healthy

  phpmyadmin:
    image: phpmyadmin:latest
    container_name: schueler_phpmyadmin
    restart: unless-stopped
    ports:
      - "8080:80"
    environment:
      PMA_HOST: db
    depends_on:
      db:
        condition: service_healthy

volumes:
  db_data:
SCHUELERLISTE_EOF
cat > db/01-schuelerdatenbank.sql <<'SCHUELERLISTE_EOF'
-- =====================================================================
-- AA 3.1: ER-Modellierung und SQL - Schülerliste
-- Physisches Modell zum ER-Modell (MySQL / MariaDB)
-- Grundlage: Relationales_Modell_Schuelerdatenbank.xlsx,
--            Data_Dictionary_Schuelerdatenbank.xlsx, ER-Modell.dia
-- Hinweis: Tabelle SCHÜLER heißt hier SCHUELER (ohne Umlaut),
--          damit das Skript auf jedem System ohne Backticks läuft.
-- =====================================================================

SET NAMES utf8mb4;  -- Umlaute korrekt übertragen

DROP DATABASE IF EXISTS schuelerdatenbank;
CREATE DATABASE schuelerdatenbank
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE schuelerdatenbank;

-- ---------------------------------------------------------------------
-- Stammdaten
-- ---------------------------------------------------------------------

-- ORT: Postleitzahl und Gemeinde (1:N mit SCHUELER)
CREATE TABLE ORT (
    PLZ        VARCHAR(10)  NOT NULL,
    Ortsname   VARCHAR(100) NOT NULL,
    CONSTRAINT pk_ort PRIMARY KEY (PLZ),
    -- Domäne: Ziffern, Format 9999 (Österreich), international max. 10 Stellen
    CONSTRAINT chk_ort_plz CHECK (PLZ REGEXP '^[0-9]{4,10}$')
);

-- KLASSE: Schulklasse (1:N mit SCHUELER)
CREATE TABLE KLASSE (
    Klassen_ID   INT          NOT NULL AUTO_INCREMENT,
    Klassenname  VARCHAR(10)  NOT NULL,
    Zweig        VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_klasse PRIMARY KEY (Klassen_ID),
    CONSTRAINT uq_klasse_name UNIQUE (Klassenname),
    -- Domäne: alphanumerischer Code, z. B. '3aWI', '1aHEIT'
    CONSTRAINT chk_klasse_name CHECK (Klassenname REGEXP '^[0-9][a-zA-Z]+$')
);

-- ---------------------------------------------------------------------
-- Hauptentität
-- ---------------------------------------------------------------------

CREATE TABLE SCHUELER (
    Schueler_ID    INT          NOT NULL AUTO_INCREMENT,
    Vorname        VARCHAR(50)  NOT NULL,
    Nachname       VARCHAR(50)  NOT NULL,
    Geburtsdatum   DATE         NOT NULL,
    Geschlecht     VARCHAR(10)  NULL,
    Strasse        VARCHAR(100) NOT NULL,
    Hausnummer     VARCHAR(10)  NOT NULL,
    HTL_Start      INT          NOT NULL,
    HTL_Ende       INT          NOT NULL,
    Hat_Auto       BOOLEAN      NOT NULL DEFAULT FALSE,
    Hat_Parkplatz  BOOLEAN      NOT NULL DEFAULT FALSE,
    PLZ            VARCHAR(10)  NOT NULL,
    Klassen_ID     INT          NOT NULL,
    CONSTRAINT pk_schueler PRIMARY KEY (Schueler_ID),
    CONSTRAINT fk_schueler_ort FOREIGN KEY (PLZ)
        REFERENCES ORT (PLZ)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_schueler_klasse FOREIGN KEY (Klassen_ID)
        REFERENCES KLASSE (Klassen_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    -- Domänen laut Data Dictionary
    CONSTRAINT chk_schueler_geschlecht
        CHECK (Geschlecht IN ('Männlich', 'Weiblich', 'Divers')),
    CONSTRAINT chk_schueler_htl_start CHECK (HTL_Start BETWEEN 2000 AND 2100),
    CONSTRAINT chk_schueler_htl_ende  CHECK (HTL_Ende  BETWEEN 2000 AND 2100),
    CONSTRAINT chk_schueler_htl_zeitraum CHECK (HTL_Ende > HTL_Start),
    -- Regel: ohne Auto kein Schulparkplatz
    CONSTRAINT chk_schueler_parkplatz CHECK (Hat_Parkplatz = FALSE OR Hat_Auto = TRUE)
);

-- ---------------------------------------------------------------------
-- Katalogtabellen
-- ---------------------------------------------------------------------

CREATE TABLE FUEHRERSCHEINKLASSE (
    FS_Klasse_ID  INT          NOT NULL AUTO_INCREMENT,
    Bezeichnung   VARCHAR(10)  NOT NULL,
    CONSTRAINT pk_fuehrerscheinklasse PRIMARY KEY (FS_Klasse_ID),
    CONSTRAINT uq_fuehrerscheinklasse_bez UNIQUE (Bezeichnung)
);

CREATE TABLE FAHRTMITTEL (
    Fahrtmittel_ID  INT          NOT NULL AUTO_INCREMENT,
    Bezeichnung     VARCHAR(30)  NOT NULL,
    CONSTRAINT pk_fahrtmittel PRIMARY KEY (Fahrtmittel_ID),
    CONSTRAINT uq_fahrtmittel_bez UNIQUE (Bezeichnung)
);

CREATE TABLE HOBBY (
    Hobby_ID     INT          NOT NULL AUTO_INCREMENT,
    Bezeichnung  VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_hobby PRIMARY KEY (Hobby_ID),
    CONSTRAINT uq_hobby_bez UNIQUE (Bezeichnung)
);

-- ---------------------------------------------------------------------
-- Zwischentabellen (M:N), zusammengesetzter PK aus zwei FKs
-- ---------------------------------------------------------------------

CREATE TABLE SCHUELER_FUEHRERSCHEIN (
    Schueler_ID   INT NOT NULL,
    FS_Klasse_ID  INT NOT NULL,
    CONSTRAINT pk_schueler_fuehrerschein PRIMARY KEY (Schueler_ID, FS_Klasse_ID),
    CONSTRAINT fk_sf_schueler FOREIGN KEY (Schueler_ID)
        REFERENCES SCHUELER (Schueler_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_sf_fsklasse FOREIGN KEY (FS_Klasse_ID)
        REFERENCES FUEHRERSCHEINKLASSE (FS_Klasse_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE SCHUELER_FAHRTMITTEL (
    Schueler_ID     INT NOT NULL,
    Fahrtmittel_ID  INT NOT NULL,
    CONSTRAINT pk_schueler_fahrtmittel PRIMARY KEY (Schueler_ID, Fahrtmittel_ID),
    CONSTRAINT fk_sfm_schueler FOREIGN KEY (Schueler_ID)
        REFERENCES SCHUELER (Schueler_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_sfm_fahrtmittel FOREIGN KEY (Fahrtmittel_ID)
        REFERENCES FAHRTMITTEL (Fahrtmittel_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE SCHUELER_HOBBY (
    Schueler_ID  INT NOT NULL,
    Hobby_ID     INT NOT NULL,
    CONSTRAINT pk_schueler_hobby PRIMARY KEY (Schueler_ID, Hobby_ID),
    CONSTRAINT fk_sh_schueler FOREIGN KEY (Schueler_ID)
        REFERENCES SCHUELER (Schueler_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_sh_hobby FOREIGN KEY (Hobby_ID)
        REFERENCES HOBBY (Hobby_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ---------------------------------------------------------------------
-- Beispieldaten (Werte aus der Spalte "Beispielwert" im Data Dictionary)
-- ---------------------------------------------------------------------

INSERT INTO ORT (PLZ, Ortsname) VALUES
    ('6850', 'Dornbirn'),
    ('6840', 'Götzis'),
    ('6900', 'Bregenz');

INSERT INTO KLASSE (Klassenname, Zweig) VALUES
    ('3aWI', 'Betriebsinformatik'),
    ('1aHEIT', 'Elektronik und technische Informatik');

INSERT INTO FUEHRERSCHEINKLASSE (Bezeichnung) VALUES
    ('AM'), ('A1'), ('B'), ('C');

INSERT INTO FAHRTMITTEL (Bezeichnung) VALUES
    ('Zug'), ('Bus'), ('Moped'), ('Fahrrad'), ('Auto');

INSERT INTO HOBBY (Bezeichnung) VALUES
    ('Zocken'), ('Fußball'), ('Breakdance'), ('Business');

INSERT INTO SCHUELER
    (Vorname, Nachname, Geburtsdatum, Geschlecht, Strasse, Hausnummer,
     HTL_Start, HTL_Ende, Hat_Auto, Hat_Parkplatz, PLZ, Klassen_ID)
VALUES
    ('Zen Eddin', 'Al Assaf', '2009-03-01', 'Männlich', 'Ring Appenzeller Str.', '13a',
     2024, 2029, FALSE, FALSE, '6840', 1);

INSERT INTO SCHUELER_FUEHRERSCHEIN (Schueler_ID, FS_Klasse_ID) VALUES (1, 1);
INSERT INTO SCHUELER_FAHRTMITTEL  (Schueler_ID, Fahrtmittel_ID) VALUES (1, 1), (1, 2);
INSERT INTO SCHUELER_HOBBY        (Schueler_ID, Hobby_ID)       VALUES (1, 1);

-- ---------------------------------------------------------------------
-- Regel aus der Angabe: Sternzeichen wird aus dem Geburtsdatum
-- abgeleitet (abgeleitetes Attribut -> nicht gespeichert, sondern View)
-- ---------------------------------------------------------------------

CREATE VIEW V_SCHUELER_STERNZEICHEN AS
SELECT
    s.Schueler_ID,
    s.Vorname,
    s.Nachname,
    s.Geburtsdatum,
    CASE
        WHEN DATE_FORMAT(s.Geburtsdatum, '%m%d') BETWEEN '0321' AND '0419' THEN 'Widder'
        WHEN DATE_FORMAT(s.Geburtsdatum, '%m%d') BETWEEN '0420' AND '0520' THEN 'Stier'
        WHEN DATE_FORMAT(s.Geburtsdatum, '%m%d') BETWEEN '0521' AND '0620' THEN 'Zwillinge'
        WHEN DATE_FORMAT(s.Geburtsdatum, '%m%d') BETWEEN '0621' AND '0722' THEN 'Krebs'
        WHEN DATE_FORMAT(s.Geburtsdatum, '%m%d') BETWEEN '0723' AND '0822' THEN 'Löwe'
        WHEN DATE_FORMAT(s.Geburtsdatum, '%m%d') BETWEEN '0823' AND '0922' THEN 'Jungfrau'
        WHEN DATE_FORMAT(s.Geburtsdatum, '%m%d') BETWEEN '0923' AND '1022' THEN 'Waage'
        WHEN DATE_FORMAT(s.Geburtsdatum, '%m%d') BETWEEN '1023' AND '1121' THEN 'Skorpion'
        WHEN DATE_FORMAT(s.Geburtsdatum, '%m%d') BETWEEN '1122' AND '1221' THEN 'Schütze'
        WHEN DATE_FORMAT(s.Geburtsdatum, '%m%d') BETWEEN '0120' AND '0218' THEN 'Wassermann'
        WHEN DATE_FORMAT(s.Geburtsdatum, '%m%d') BETWEEN '0219' AND '0320' THEN 'Fische'
        ELSE 'Steinbock'
    END AS Sternzeichen
FROM SCHUELER s;

-- ---------------------------------------------------------------------
-- Übersicht: Schülerliste mit Ort und Klasse
-- ---------------------------------------------------------------------

CREATE VIEW V_SCHUELERLISTE AS
SELECT
    s.Schueler_ID,
    s.Vorname,
    s.Nachname,
    k.Klassenname,
    k.Zweig,
    CONCAT(s.Strasse, ' ', s.Hausnummer) AS Adresse,
    o.PLZ,
    o.Ortsname
FROM SCHUELER s
JOIN KLASSE k ON k.Klassen_ID = s.Klassen_ID
JOIN ORT    o ON o.PLZ        = s.PLZ;

-- Testabfragen
SELECT * FROM V_SCHUELERLISTE;
SELECT * FROM V_SCHUELER_STERNZEICHEN;
SCHUELERLISTE_EOF
cat > db/02-webuser.sql <<'SCHUELERLISTE_EOF'
-- Lese-Benutzer für die Webseite (Zugriff aus dem Docker-Netz)
CREATE USER IF NOT EXISTS 'webuser'@'%' IDENTIFIED BY 'Schueler2026!';
GRANT SELECT ON schuelerdatenbank.* TO 'webuser'@'%';
FLUSH PRIVILEGES;
SCHUELERLISTE_EOF
cat > web/Dockerfile <<'SCHUELERLISTE_EOF'
FROM php:8.3-apache
RUN docker-php-ext-install pdo_mysql
COPY index.php /var/www/html/index.php
SCHUELERLISTE_EOF
cat > web/index.php <<'SCHUELERLISTE_EOF'
<?php
// Schülerliste – liest die Daten aus der Datenbank "schuelerdatenbank"
$host = getenv('DB_HOST') ?: 'localhost';
$db   = getenv('DB_NAME') ?: 'schuelerdatenbank';
$user = getenv('DB_USER') ?: 'webuser';
$pass = getenv('DB_PASS') ?: 'Schueler2026!';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db;charset=utf8mb4", $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
} catch (PDOException $e) {
    http_response_code(500);
    die('Datenbankverbindung fehlgeschlagen: ' . htmlspecialchars($e->getMessage()));
}

$sql = "
SELECT
    s.Schueler_ID, s.Vorname, s.Nachname, s.Geburtsdatum, s.Geschlecht,
    k.Klassenname, k.Zweig,
    CONCAT(s.Strasse, ' ', s.Hausnummer) AS Adresse, o.PLZ, o.Ortsname,
    s.HTL_Start, s.HTL_Ende, s.Hat_Auto, s.Hat_Parkplatz,
    st.Sternzeichen,
    (SELECT GROUP_CONCAT(f.Bezeichnung ORDER BY f.Bezeichnung SEPARATOR ', ')
       FROM SCHUELER_FUEHRERSCHEIN sf JOIN FUEHRERSCHEINKLASSE f ON f.FS_Klasse_ID = sf.FS_Klasse_ID
      WHERE sf.Schueler_ID = s.Schueler_ID) AS Fuehrerscheine,
    (SELECT GROUP_CONCAT(fm.Bezeichnung ORDER BY fm.Bezeichnung SEPARATOR ', ')
       FROM SCHUELER_FAHRTMITTEL sfm JOIN FAHRTMITTEL fm ON fm.Fahrtmittel_ID = sfm.Fahrtmittel_ID
      WHERE sfm.Schueler_ID = s.Schueler_ID) AS Fahrtmittel,
    (SELECT GROUP_CONCAT(h.Bezeichnung ORDER BY h.Bezeichnung SEPARATOR ', ')
       FROM SCHUELER_HOBBY sh JOIN HOBBY h ON h.Hobby_ID = sh.Hobby_ID
      WHERE sh.Schueler_ID = s.Schueler_ID) AS Hobbys
FROM SCHUELER s
JOIN KLASSE k ON k.Klassen_ID = s.Klassen_ID
JOIN ORT    o ON o.PLZ        = s.PLZ
JOIN V_SCHUELER_STERNZEICHEN st ON st.Schueler_ID = s.Schueler_ID
ORDER BY k.Klassenname, s.Nachname, s.Vorname";

$schueler = $pdo->query($sql)->fetchAll();

function e($v) { return htmlspecialchars((string)($v ?? '–'), ENT_QUOTES, 'UTF-8'); }
function janein($v) { return $v ? 'Ja' : 'Nein'; }
?>
<!DOCTYPE html>
<html lang="de">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Schülerliste</title>
<style>
    body { font-family: Segoe UI, Arial, sans-serif; margin: 2rem; background: #f4f6f9; color: #222; }
    h1 { color: #1f4e79; }
    table { border-collapse: collapse; width: 100%; background: #fff; box-shadow: 0 1px 3px rgba(0,0,0,.1); }
    th, td { padding: .5rem .7rem; border-bottom: 1px solid #ddd; text-align: left; font-size: .9rem; }
    th { background: #1f4e79; color: #fff; position: sticky; top: 0; }
    tr:nth-child(even) td { background: #f2f6fb; }
    .anzahl { color: #555; margin-bottom: 1rem; }
</style>
</head>
<body>
<h1>Schülerliste</h1>
<p class="anzahl"><?= count($schueler) ?> Schüler in der Datenbank</p>
<table>
    <thead>
    <tr>
        <th>Nr.</th><th>Vorname</th><th>Nachname</th><th>Klasse</th><th>Zweig</th>
        <th>Geburtsdatum</th><th>Sternzeichen</th><th>Geschlecht</th>
        <th>Adresse</th><th>PLZ</th><th>Ort</th><th>HTL</th>
        <th>Auto</th><th>Parkplatz</th><th>Führerschein</th><th>Fahrtmittel</th><th>Hobbys</th>
    </tr>
    </thead>
    <tbody>
    <?php foreach ($schueler as $s): ?>
    <tr>
        <td><?= e($s['Schueler_ID']) ?></td>
        <td><?= e($s['Vorname']) ?></td>
        <td><?= e($s['Nachname']) ?></td>
        <td><?= e($s['Klassenname']) ?></td>
        <td><?= e($s['Zweig']) ?></td>
        <td><?= e(date('d.m.Y', strtotime($s['Geburtsdatum']))) ?></td>
        <td><?= e($s['Sternzeichen']) ?></td>
        <td><?= e($s['Geschlecht']) ?></td>
        <td><?= e($s['Adresse']) ?></td>
        <td><?= e($s['PLZ']) ?></td>
        <td><?= e($s['Ortsname']) ?></td>
        <td><?= e($s['HTL_Start']) ?>–<?= e($s['HTL_Ende']) ?></td>
        <td><?= janein($s['Hat_Auto']) ?></td>
        <td><?= janein($s['Hat_Parkplatz']) ?></td>
        <td><?= e($s['Fuehrerscheine']) ?></td>
        <td><?= e($s['Fahrtmittel']) ?></td>
        <td><?= e($s['Hobbys']) ?></td>
    </tr>
    <?php endforeach; ?>
    </tbody>
</table>
</body>
</html>
SCHUELERLISTE_EOF
echo "Fertig. Dateien:"; find ~/schuelerliste -type f

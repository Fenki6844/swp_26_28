mkdir -p ~/schuelerliste/db && cd ~/schuelerliste
cat > db/update_schueler.sql <<'SCHUELERLISTE_EOF'
-- Update: ersetzt alle Daten durch die vollständige Schülerliste (11 Schüler)
-- Tabellenstruktur, Views und Benutzer bleiben erhalten.
SET NAMES utf8mb4;
USE schuelerdatenbank;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE SCHUELER_HOBBY;
TRUNCATE TABLE SCHUELER_FAHRTMITTEL;
TRUNCATE TABLE SCHUELER_FUEHRERSCHEIN;
TRUNCATE TABLE SCHUELER;
TRUNCATE TABLE HOBBY;
TRUNCATE TABLE FAHRTMITTEL;
TRUNCATE TABLE FUEHRERSCHEINKLASSE;
TRUNCATE TABLE KLASSE;
TRUNCATE TABLE ORT;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO ORT (PLZ, Ortsname) VALUES
    ('6811', 'Göfis'),
    ('6833', 'Klaus'),
    ('6840', 'Götzis'),
    ('6844', 'Altach'),
    ('6845', 'Hohenems'),
    ('6850', 'Dornbirn'),
    ('6890', 'Lustenau');

INSERT INTO KLASSE (Klassenname, Zweig) VALUES
    ('3aWI', 'Betriebsinformatik');

INSERT INTO FUEHRERSCHEINKLASSE (Bezeichnung) VALUES
    ('AM'),
    ('B');

INSERT INTO FAHRTMITTEL (Bezeichnung) VALUES
    ('Auto'),
    ('Bus'),
    ('Fahrrad'),
    ('Moped'),
    ('Zug');

INSERT INTO HOBBY (Bezeichnung) VALUES
    ('Breakdance'),
    ('Business'),
    ('Fußball'),
    ('Moped'),
    ('Schlagzeug'),
    ('Zocken');

INSERT INTO SCHUELER
    (Schueler_ID, Vorname, Nachname, Geburtsdatum, Geschlecht, Strasse, Hausnummer,
     HTL_Start, HTL_Ende, Hat_Auto, Hat_Parkplatz, PLZ, Klassen_ID)
VALUES
    (1, 'Zen Eddin', 'Al Assaf', '2009-03-01', 'Männlich', 'Ring Appenzeller str.', '13a', 2024, 2029, FALSE, FALSE, '6840', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (2, 'Mevlütcan', 'Alici', '2008-09-21', 'Männlich', 'Weppach', '21a', 2024, 2029, FALSE, FALSE, '6850', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (3, 'Tim', 'Bildstein', '2009-12-29', 'Männlich', 'Bergmannstraße', '13', 2024, 2029, FALSE, FALSE, '6850', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (4, 'Elias', 'Engelking', '2010-02-15', 'Männlich', 'Gartenstraße', '15a', 2024, 2029, FALSE, FALSE, '6833', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (5, 'Gabriel', 'Fenkart', '2010-01-07', 'Männlich', 'Wichnersiedlung', '2', 2024, 2029, FALSE, FALSE, '6844', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (6, 'Joel', 'Fiel', '2006-10-13', 'Männlich', 'Milchstraße', '1a', 2021, 2029, FALSE, FALSE, '6890', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (7, 'Nico', 'Gstöhl', '2010-05-12', 'Männlich', 'Badrus', '4', 2024, 2029, FALSE, FALSE, '6811', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (8, 'Aurel', 'Hilbrand', '2010-01-29', 'Männlich', 'Brändlestraße', '15a', 2024, 2029, FALSE, FALSE, '6844', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (9, 'Vincent', 'Hunker', '2010-05-10', 'Männlich', 'Sandgasse', '40a', 2024, 2029, FALSE, FALSE, '6850', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (10, 'Ensar', 'Kandemir', '2010-06-30', 'Männlich', 'Hermann-Prey-Straße', '4c', 2024, 2029, FALSE, FALSE, '6845', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (11, 'Laurin', 'Köck', '2010-05-11', 'Männlich', 'Steinstraße', '7d', 2024, 2029, FALSE, FALSE, '6845', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI'));

INSERT INTO SCHUELER_FUEHRERSCHEIN (Schueler_ID, FS_Klasse_ID)
SELECT 2, FS_Klasse_ID FROM FUEHRERSCHEINKLASSE WHERE Bezeichnung = 'B'
UNION ALL SELECT 4, FS_Klasse_ID FROM FUEHRERSCHEINKLASSE WHERE Bezeichnung = 'AM'
UNION ALL SELECT 5, FS_Klasse_ID FROM FUEHRERSCHEINKLASSE WHERE Bezeichnung = 'AM'
UNION ALL SELECT 6, FS_Klasse_ID FROM FUEHRERSCHEINKLASSE WHERE Bezeichnung = 'B'
UNION ALL SELECT 7, FS_Klasse_ID FROM FUEHRERSCHEINKLASSE WHERE Bezeichnung = 'AM'
UNION ALL SELECT 11, FS_Klasse_ID FROM FUEHRERSCHEINKLASSE WHERE Bezeichnung = 'AM';

INSERT INTO SCHUELER_FAHRTMITTEL (Schueler_ID, Fahrtmittel_ID)
SELECT 1, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Zug'
UNION ALL SELECT 2, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Auto'
UNION ALL SELECT 2, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Bus'
UNION ALL SELECT 2, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Zug'
UNION ALL SELECT 3, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Bus'
UNION ALL SELECT 4, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Zug'
UNION ALL SELECT 5, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Moped'
UNION ALL SELECT 5, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Zug'
UNION ALL SELECT 6, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Bus'
UNION ALL SELECT 7, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Moped'
UNION ALL SELECT 7, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Bus'
UNION ALL SELECT 7, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Zug'
UNION ALL SELECT 8, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Zug'
UNION ALL SELECT 9, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Fahrrad'
UNION ALL SELECT 10, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Bus'
UNION ALL SELECT 10, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Zug'
UNION ALL SELECT 11, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Zug'
UNION ALL SELECT 11, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Bus';

INSERT INTO SCHUELER_HOBBY (Schueler_ID, Hobby_ID)
SELECT 1, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Zocken'
UNION ALL SELECT 2, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Fußball'
UNION ALL SELECT 3, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Zocken'
UNION ALL SELECT 4, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Zocken'
UNION ALL SELECT 5, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Moped'
UNION ALL SELECT 6, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Business'
UNION ALL SELECT 7, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Zocken'
UNION ALL SELECT 8, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Breakdance'
UNION ALL SELECT 9, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Fußball'
UNION ALL SELECT 10, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Fußball'
UNION ALL SELECT 11, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Schlagzeug';

SELECT COUNT(*) AS Anzahl_Schueler FROM SCHUELER;
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
-- Daten aus Schülerinformationen_Liste_1.xlsx (11 Schüler)
-- ---------------------------------------------------------------------

INSERT INTO ORT (PLZ, Ortsname) VALUES
    ('6811', 'Göfis'),
    ('6833', 'Klaus'),
    ('6840', 'Götzis'),
    ('6844', 'Altach'),
    ('6845', 'Hohenems'),
    ('6850', 'Dornbirn'),
    ('6890', 'Lustenau');

INSERT INTO KLASSE (Klassenname, Zweig) VALUES
    ('3aWI', 'Betriebsinformatik');

INSERT INTO FUEHRERSCHEINKLASSE (Bezeichnung) VALUES
    ('AM'),
    ('B');

INSERT INTO FAHRTMITTEL (Bezeichnung) VALUES
    ('Auto'),
    ('Bus'),
    ('Fahrrad'),
    ('Moped'),
    ('Zug');

INSERT INTO HOBBY (Bezeichnung) VALUES
    ('Breakdance'),
    ('Business'),
    ('Fußball'),
    ('Moped'),
    ('Schlagzeug'),
    ('Zocken');

INSERT INTO SCHUELER
    (Schueler_ID, Vorname, Nachname, Geburtsdatum, Geschlecht, Strasse, Hausnummer,
     HTL_Start, HTL_Ende, Hat_Auto, Hat_Parkplatz, PLZ, Klassen_ID)
VALUES
    (1, 'Zen Eddin', 'Al Assaf', '2009-03-01', 'Männlich', 'Ring Appenzeller str.', '13a', 2024, 2029, FALSE, FALSE, '6840', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (2, 'Mevlütcan', 'Alici', '2008-09-21', 'Männlich', 'Weppach', '21a', 2024, 2029, FALSE, FALSE, '6850', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (3, 'Tim', 'Bildstein', '2009-12-29', 'Männlich', 'Bergmannstraße', '13', 2024, 2029, FALSE, FALSE, '6850', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (4, 'Elias', 'Engelking', '2010-02-15', 'Männlich', 'Gartenstraße', '15a', 2024, 2029, FALSE, FALSE, '6833', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (5, 'Gabriel', 'Fenkart', '2010-01-07', 'Männlich', 'Wichnersiedlung', '2', 2024, 2029, FALSE, FALSE, '6844', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (6, 'Joel', 'Fiel', '2006-10-13', 'Männlich', 'Milchstraße', '1a', 2021, 2029, FALSE, FALSE, '6890', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (7, 'Nico', 'Gstöhl', '2010-05-12', 'Männlich', 'Badrus', '4', 2024, 2029, FALSE, FALSE, '6811', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (8, 'Aurel', 'Hilbrand', '2010-01-29', 'Männlich', 'Brändlestraße', '15a', 2024, 2029, FALSE, FALSE, '6844', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (9, 'Vincent', 'Hunker', '2010-05-10', 'Männlich', 'Sandgasse', '40a', 2024, 2029, FALSE, FALSE, '6850', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (10, 'Ensar', 'Kandemir', '2010-06-30', 'Männlich', 'Hermann-Prey-Straße', '4c', 2024, 2029, FALSE, FALSE, '6845', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI')),
    (11, 'Laurin', 'Köck', '2010-05-11', 'Männlich', 'Steinstraße', '7d', 2024, 2029, FALSE, FALSE, '6845', (SELECT Klassen_ID FROM KLASSE WHERE Klassenname = '3aWI'));

INSERT INTO SCHUELER_FUEHRERSCHEIN (Schueler_ID, FS_Klasse_ID)
SELECT 2, FS_Klasse_ID FROM FUEHRERSCHEINKLASSE WHERE Bezeichnung = 'B'
UNION ALL SELECT 4, FS_Klasse_ID FROM FUEHRERSCHEINKLASSE WHERE Bezeichnung = 'AM'
UNION ALL SELECT 5, FS_Klasse_ID FROM FUEHRERSCHEINKLASSE WHERE Bezeichnung = 'AM'
UNION ALL SELECT 6, FS_Klasse_ID FROM FUEHRERSCHEINKLASSE WHERE Bezeichnung = 'B'
UNION ALL SELECT 7, FS_Klasse_ID FROM FUEHRERSCHEINKLASSE WHERE Bezeichnung = 'AM'
UNION ALL SELECT 11, FS_Klasse_ID FROM FUEHRERSCHEINKLASSE WHERE Bezeichnung = 'AM';

INSERT INTO SCHUELER_FAHRTMITTEL (Schueler_ID, Fahrtmittel_ID)
SELECT 1, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Zug'
UNION ALL SELECT 2, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Auto'
UNION ALL SELECT 2, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Bus'
UNION ALL SELECT 2, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Zug'
UNION ALL SELECT 3, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Bus'
UNION ALL SELECT 4, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Zug'
UNION ALL SELECT 5, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Moped'
UNION ALL SELECT 5, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Zug'
UNION ALL SELECT 6, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Bus'
UNION ALL SELECT 7, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Moped'
UNION ALL SELECT 7, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Bus'
UNION ALL SELECT 7, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Zug'
UNION ALL SELECT 8, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Zug'
UNION ALL SELECT 9, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Fahrrad'
UNION ALL SELECT 10, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Bus'
UNION ALL SELECT 10, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Zug'
UNION ALL SELECT 11, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Zug'
UNION ALL SELECT 11, Fahrtmittel_ID FROM FAHRTMITTEL WHERE Bezeichnung = 'Bus';

INSERT INTO SCHUELER_HOBBY (Schueler_ID, Hobby_ID)
SELECT 1, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Zocken'
UNION ALL SELECT 2, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Fußball'
UNION ALL SELECT 3, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Zocken'
UNION ALL SELECT 4, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Zocken'
UNION ALL SELECT 5, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Moped'
UNION ALL SELECT 6, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Business'
UNION ALL SELECT 7, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Zocken'
UNION ALL SELECT 8, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Breakdance'
UNION ALL SELECT 9, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Fußball'
UNION ALL SELECT 10, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Fußball'
UNION ALL SELECT 11, Hobby_ID FROM HOBBY WHERE Bezeichnung = 'Schlagzeug';

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
docker exec -i schueler_db mariadb -uroot -p'RootPasswort2026!' < db/update_schueler.sql

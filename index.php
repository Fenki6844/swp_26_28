<?php
$host = 'localhost';
$db   = 'schuelerdatenbank';
$user = 'webuser';
$pass = 'Schueler2026!';

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

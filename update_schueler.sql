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

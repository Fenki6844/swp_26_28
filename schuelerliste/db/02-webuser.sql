-- Lese-Benutzer für die Webseite (Zugriff aus dem Docker-Netz)
CREATE USER IF NOT EXISTS 'webuser'@'%' IDENTIFIED BY 'Schueler2026!';
GRANT SELECT ON schuelerdatenbank.* TO 'webuser'@'%';
FLUSH PRIVILEGES;

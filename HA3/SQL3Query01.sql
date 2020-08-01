-- Aufgabe 1 (Teil 1):
-- Funktion um die Tabelle KundenKontaktDaten zu erstellen. Falls die Tabelle
-- bereits existiert, soll ihr Inhalt gelöscht werden.
--
-- Punkte:
-- 0.5
--

CREATE TABLE KundenKontaktDaten (
    Kunden_Nr INTEGER NOT NULL PRIMARY KEY,
    Twitter_Id VARCHAR(40),
    Google_Id BIGINT,
    Facebook_Id BIGINT,
    Skype_Id VARCHAR(64),
    Telefonnummer VARCHAR(50)
)
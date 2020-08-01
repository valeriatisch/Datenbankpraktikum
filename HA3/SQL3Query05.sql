-- Aufgabe 5:
-- Funktion um der Tabelle KundenKontaktDaten ein check constraint
-- mit dem Namen Telefonnummer_CHECK auf das Attribut Telefonnummer
-- hinzuzufügen.
--
-- Das Check Constraint soll sicher stellen dass:
-- - Jede Nummer die Landvorwahl für Deutschland +49 hat
-- - Nach der +49 Vorwahl eine Zahl zwischen 150 und 180 folgt
-- - Nach der Netzvorwahl zwischen 8 und 10 Ziffern kommen
-- - Landesvorwahl, Netzvorwahl und Nummer durch ein Leerzeichen getrennt
-- werden
--
-- Punkte:
-- 2
--

ALTER TABLE KundenKontaktDaten
    ADD CONSTRAINT Telefonnummer_CHECK
        CHECK (
                SUBSTR(Telefonnummer, 1, 4) = '+49 '
                AND INT(SUBSTR(Telefonnummer, 5, 3)) BETWEEN 150 AND 180
                AND SUBSTR(Telefonnummer, 8, 1) = ' '
                AND LENGTH(Telefonnummer) BETWEEN 16 AND 18
                AND LENGTH(TRIM(TRANSLATE(Telefonnummer, ' ', '+0123456789'))) = 0
            );
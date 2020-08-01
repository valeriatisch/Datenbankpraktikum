-- Aufgabe 3:
-- Funktion um der Tabelle KundenKontaktDaten ein check constraint
-- mit dem Namen TwitterID_Check auf das Attribut Twitter_ID hinzuzufügen.
--
-- Das Check Constraint soll sicher stellen dass:
-- - Alle Twitter_IDs mit @ anfangen.
-- - Und nach dem @ eine Zeichenkette folgt, die
-- o Maximal 31 Zeichen lang ist
-- o Nur aus kleinen lateinische Buchstaben, Zahlen, und '_' besteht.
--
-- Punkte:
-- 2

ALTER TABLE KundenKontaktDaten
    ADD CONSTRAINT TwitterID_Check
        CHECK (
            SUBSTR(Twitter_Id, 1, 1) = '@'
                   AND LENGTH(TRIM('@' FROM Twitter_Id)) <= 31
                   AND LENGTH(TRIM(TRANSLATE(TRIM('@' FROM Twitter_Id), ' ', 'abcdefghijklmnopqrstuvwxyz_0123456789'))) = 0
            )
-- Aufgabe 4:
-- Funktion um der Tabelle KundenKontaktDaten ein check constraint
-- mit dem Namen GoogleUndFacebookID_CHECK auf die Attribute Google_ID und
-- Facebook_ID hinzuzufügen.
--
-- Das Check Constraint soll sicher stellen dass:
-- - Alle Google und FacebookIDs im Intervall [10000000,99999999] liegen.
-- - Keine verbotenen IDs verwendet werden.
-- o Google verbietet: 10000042, 10000007, 10000666
-- o Facebook verbietet: 10004321, 10097242, 12345678
--
-- Punkte:
-- 1
--

ALTER TABLE KundenKontaktDaten
    ADD CONSTRAINT GoogleUndFacebookID_CHECK
        CHECK (
            Facebook_Id BETWEEN 10000000 AND 99999999
                  AND Google_Id BETWEEN 10000000 AND 99999999
                  AND Facebook_Id NOT IN (10004321, 10097242, 12345678)
                  AND Google_Id NOT IN (10000042, 10000007, 10000666)
            )
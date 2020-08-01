-- Aufgabe 6:
-- Funktion um der Tabelle KundenKontaktDaten ein check constraint
-- mit dem Namen MindestensEinKontakt_CHECK hinzuzufügen.
--
-- Das Check Constraint soll sicher stellen dass mindestens eines der Attribute
-- TWITTER_ID, GOOGLE_ID, FACEBOOK_ID, SKYPE_ID, TELEFONNUMMER nicht NULL ist.
--
-- Punkte:
-- 1
--

ALTER TABLE KundenKontaktDaten
ADD CONSTRAINT MindestensEinKontakt_CHECK
CHECK (
    (Twitter_Id IS NOT NULL) OR
    (Google_Id  IS NOT NULL) OR
    (Facebook_Id  IS NOT NULL) OR
    (Skype_Id  IS NOT NULL) OR
    (Telefonnummer  IS NOT NULL)
    )
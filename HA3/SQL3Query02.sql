-- Aufgabe 2:
-- Funktion um der Tabelle KundenKontaktDaten ein referential constraint
-- mit dem Namen KundenKontaktDaten_Kunden_FK auf Kunde hinzuzufügen.
--
-- Punkte:
-- 1
--

ALTER TABLE KundenKontaktDaten
ADD CONSTRAINT KundenKontaktDaten_Kunden_FK
    FOREIGN KEY (Kunden_Nr) REFERENCES KUNDE(Kunden_Nr)
ON DELETE CASCADE
ON UPDATE RESTRICT
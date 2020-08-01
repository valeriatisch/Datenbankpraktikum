-- Aufgabe 4:
-- (siehe Folien)
--
-- Punkte:
-- 2.0
--

CREATE OR REPLACE TRIGGER PolarMessungen_Update
INSTEAD OF UPDATE ON PolarMessungen
REFERENCING OLD AS o NEW AS n
FOR EACH ROW
UPDATE Messungen SET Messungen.x = DOUBLE(n.R * COS(n.Theta)), Messungen.y = DOUBLE(n.R * SIN(n.Theta))
WHERE n.series = Messungen.series AND n.id = Messungen.id
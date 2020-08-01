-- Aufgabe 2:
-- Messungen
-- (siehe Folien)
--
-- Punkte:
-- 1.5
--

CREATE VIEW PolarMessungen AS (
SELECT series, id, R(x, y) AS R, THETA(x, y) AS Theta
FROM Messungen
)
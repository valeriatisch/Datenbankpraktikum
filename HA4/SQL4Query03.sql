-- Aufgabe 3:
-- MessungStatistik
-- (siehe Folien)
--
-- Punkte:
-- 1.5
--

CREATE VIEW MessungStatistik AS (
SELECT series, MAX(Theta) - MIN(Theta) AS AngularSpread, AVG(R) AS AvgLength
FROM PolarMessungen
GROUP BY series
)
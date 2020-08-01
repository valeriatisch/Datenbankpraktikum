-- Queryergebnis:
-- Finden Sie für alle Marken diejenigen Artikel, die in den obersten 1% der Preisspanne der Marke sind.
-- Die Preisspanne ist die Differenz zwischen dem billigsten und dem teuersten Artikel.
--
-- Ergebnisschema:
-- [Marke (↑1) | Name (↑2) ]
--
-- Punkte:
-- 1.0
--
-- @return SQL Query für Aufgabe 8
--

SELECT A1.MARKE, A1.NAME
FROM ARTIKEL A1 JOIN
    (SELECT MARKE, MAX(PREIS) AS MAX_PREIS, (MAX(PREIS)-MIN(PREIS)) AS PREISSPANNE
    FROM ARTIKEL
    GROUP BY MARKE) AS A2 ON A1.MARKE = A2.MARKE
WHERE A1.PREIS > MAX_PREIS - 0.01*PREISSPANNE
ORDER BY A1.MARKE, A1.NAME
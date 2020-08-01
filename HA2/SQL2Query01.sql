-- Queryergebnis:
-- Finden Sie die Marken deren durchschnittlicher Produktpreis höher als der Durchschnittspreis aller Produkte ist.
--
-- Ergebnisschema
-- [Marke(↑) | d_preis]
--
-- Punkte:
-- 0.5
--

SELECT MARKE, AVG(PREIS) AS d_preis
FROM ARTIKEL
GROUP BY MARKE
HAVING AVG(PREIS) > (SELECT AVG(PREIS) FROM ARTIKEL)
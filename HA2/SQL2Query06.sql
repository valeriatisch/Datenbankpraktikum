-- Queryergebnis:
-- Bestimmen die Sie Marke(n), die von den meisten Lieferanten angeboten wird.
--
-- Ergebnisschema:
-- [Marke] (↑)
--
-- Punkte:
-- 1.0
--

SELECT MARKE
FROM (SELECT MARKE, COUNT(MARKE) AS MENGE
    FROM (SELECT MARKE
    FROM ARTIKEL A JOIN LIEFERT L on A.ARTIKEL_NR = L.ARTIKEL
    GROUP BY MARKE, LIEFERANT)
    GROUP BY MARKE
    ORDER BY MENGE DESC
    FETCH FIRST 1 ROWS ONLY)
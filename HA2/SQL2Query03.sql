-- Queryergebnis:
-- Finden sie für jeden Artikel des Typs "MEDIUM ANODIZED TIN" den Lieferanten aus der Region 'ASIA',
-- der für den Artikel den niedrigsten Lieferpreis hat.
-- Der Lieferpreis eines Lieferanten für einen Artikel ist das gleichnamige Attribut auf der "Liefert" Relation.
--
-- Ergebnisschema:
-- [Artikel_Nr (↑) | Lieferant_Name (↑) | Lieferpreis]
--
-- Punkte:
-- 1.0
--
--

SELECT A.ARTIKEL_NR, LT.NAME AS LIEFERANT_NAME, L.LIEFERPREIS
FROM ARTIKEL A JOIN LIEFERT L ON A.ARTIKEL_NR = L.ARTIKEL
JOIN LIEFERANT LT ON L.LIEFERANT = LT.LIEFERANTEN_NR
WHERE (A.ARTIKEL_NR, L.LIEFERPREIS) IN (SELECT A.ARTIKEL_NR, MIN(L.LIEFERPREIS) AS LIEFERPREIS
    FROM ARTIKEL A JOIN LIEFERT L ON A.ARTIKEL_NR = L.ARTIKEL
    JOIN LIEFERANT LT ON L.LIEFERANT = LT.LIEFERANTEN_NR
    JOIN LAND ON LT.LAND = LAND.LAND_ID
    JOIN REGION R on LAND.REGION = R.REGION_ID
    WHERE A.TYP = 'MEDIUM ANODIZED TIN' AND R.NAME = 'ASIA'
    GROUP BY A.ARTIKEL_NR)
ORDER BY A.ARTIKEL_NR, LT.NAME
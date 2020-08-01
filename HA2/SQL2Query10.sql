-- Queryergebnis:
-- Bestimmen Sie für alle Lieferanten aus "FRANCE" jeweils die Artikel, bei denen der verfügbare Lieferwert mehr ist,
-- als 1/500 des verfügbaren Lieferwertes aller Artikel dieses Lieferanten.
-- Der verfügbare Lieferwert eines Artikels ist das Produkt aus der verfügbaren Anzahl und dem Lieferpreis.
--
-- Ergebnisschema:
-- [Lieferanten_Nr (↑1) | Artikel (ID) | Wert (↓2)]
--
-- Punkte:
-- 1.5
--

SELECT L1.LIEFERANT AS LIEFERANTEN_NR, L1.ARTIKEL AS ARTIKEL, L1.ANZAHL_VERFUEGB*L1.LIEFERPREIS AS WERT
FROM LIEFERT L1 JOIN
    (SELECT LIEFERANT, (SUM((ANZAHL_VERFUEGB*LIEFERPREIS)))/500 AS VERF_LIEFERWERT_ALLER
    FROM LIEFERT
    GROUP BY LIEFERANT) AS L2 ON L1.LIEFERANT = L2.LIEFERANT
    JOIN LIEFERANT L on L1.LIEFERANT = L.LIEFERANTEN_NR
    JOIN LAND ON L.LAND = LAND.LAND_ID
WHERE (L1.ANZAHL_VERFUEGB*L1.LIEFERPREIS) > L2.VERF_LIEFERWERT_ALLER
    AND LAND.NAME = 'FRANCE'
ORDER BY L1.LIEFERANT, (L1.ANZAHL_VERFUEGB*L1.LIEFERPREIS) DESC
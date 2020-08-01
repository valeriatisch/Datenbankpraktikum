-- Queryergebnis:
-- Finden Sie alle Lieferanten, die keine Artikel der Marke "Brand#53" führen.
--
-- Ergebnisschema:
-- [Name(↑) | Adresse]
--
-- Punkte:
-- 0.5
--
SELECT NAME, ADRESSE
FROM LIEFERANT
WHERE LIEFERANTEN_NR NOT IN (
    SELECT LIEFERANTEN_NR
    FROM LIEFERANT
    JOIN LIEFERT L ON LIEFERANT.LIEFERANTEN_NR = L.LIEFERANT
    JOIN ARTIKEL A ON L.ARTIKEL = A.ARTIKEL_NR
    WHERE A.MARKE = 'Brand#53')
ORDER BY NAME;
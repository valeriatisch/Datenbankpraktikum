-- Queryergebnis:
-- Berechnen sie für jeden Kunden, wie viele seiner Bestellungen vollständig mit Artikeln
-- von lokalen Lieferanten erfüllt worden sind.
-- Lokaler Lieferant bedeutet, dass der Lieferant in dem gleichen Land wie der Kunde ansässig ist.
-- Geben sie alle Kunden aus, die mindestens eine solche lokale Bestellung hatten, absteigend
-- nach der Anzahl der lokalen Bestellungen.
--
-- Ergebnisschema:
-- [KundenName(↑2) | Anzahl (↓1)]
--
-- Punkte:
-- 1.5
--
--

SELECT K.NAME AS KUNDENNAME, COUNT(TAB1.BESTELL_NR) AS ANZAHL
FROM (SELECT DISTINCT B.BESTELL_NR, COUNT(B.BESTELL_NR) AS ANZAHL
    FROM BESTELLPOSTEN BP JOIN BESTELLUNG B ON BP.BESTELL_NR = B.BESTELL_NR
        JOIN KUNDE K ON B.KUNDE = K.KUNDEN_NR
        JOIN LIEFERANT L on BP.LIEFERANT = L.LIEFERANTEN_NR
    WHERE K.LAND = L.LAND
    GROUP BY B.BESTELL_NR) AS TAB1
    JOIN (SELECT BESTELL_NR, COUNT(BESTELL_NR) AS ANZAHL
        FROM BESTELLPOSTEN
        GROUP BY BESTELL_NR) AS TAB2 ON TAB1.BESTELL_NR = TAB2.BESTELL_NR AND TAB1.ANZAHL = TAB2.ANZAHL
    JOIN BESTELLUNG B ON TAB1.BESTELL_NR = B.BESTELL_NR
    JOIN KUNDE K ON K.KUNDEN_NR = B.KUNDE
GROUP BY K.NAME
ORDER BY COUNT(TAB1.BESTELL_NR) DESC
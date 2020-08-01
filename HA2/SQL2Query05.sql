-- Queryergebnis:
-- Finden Sie Bestellungen, die zwischen dem 15.07.1996 und dem 15.10.1996 (jeweils inkl.) aufgegeben wurden,
-- und bei denen mindestens ein Bestellposten später angeliefert wurde, als zugesichert.
-- Geben sie pro Bestellpriorität aus, für wie viele Bestellungen dies der Fall war.
-- Hinweis: Das Attribut "Empfangsdatum" beschreibt, wann ein Bestellposten angekommen ist.
-- Das Attribute "Bestätigungsdatum" beschreibt, für wann die Ankunft des Bestellpostens zugesichert wurde.
--
-- Ergebnisschema:
-- [Prioritaet (↑) | Anzahl]
--
-- Punkte:
-- 1.0
--

SELECT BESTELLPRIORITAET AS PRIORITAET, COUNT(DISTINCT BESTELL_NR) AS ANZAHL
FROM (SELECT B.BESTELL_NR, B.BESTELLPRIORITAET
    FROM BESTELLUNG AS B JOIN BESTELLPOSTEN AS BP ON B.BESTELL_NR = BP.BESTELL_NR
    WHERE B.BESTELLDATUM BETWEEN '1996-07-15' AND '1996-10-15'
        AND DAYS(BP.BESTAETIGUNGSDATUM) < DAYS(BP.EMPFANGSDATUM))
GROUP BY BESTELLPRIORITAET
ORDER BY BESTELLPRIORITAET
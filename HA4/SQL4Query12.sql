-- Aufgabe 1 (Teil 2):
-- Schreiben Sie zwei UDFs die (2D) kartesische Koordinaten
-- in Polarkoordinaten umrechnen.
-- (siehe Folien)
--
-- Punkte:
-- 1.0
--

CREATE FUNCTION THETA(X DOUBLE, Y DOUBLE)
    RETURNS DOUBLE
    BEGIN
    IF X=0.0 AND Y=0.0
        THEN RETURN 0.0;
    ELSE
        RETURN DOUBLE(ATAN2(X, Y));
    END IF;
    END
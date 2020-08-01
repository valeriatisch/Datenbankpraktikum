-- Aufgabe 1 (Teil 1):
-- Schreiben Sie zwei UDFs die (2D) kartesische Koordinaten
-- in Polarkoordinaten umrechnen.
-- (siehe Folien)
--
-- Punkte:
-- 1.0
--
CREATE FUNCTION R(X DOUBLE, Y DOUBLE)
    RETURNS DOUBLE
    BEGIN
        DECLARE R DOUBLE;
        SET R = SQRT(X*X + Y*Y);
        RETURN R;
    END

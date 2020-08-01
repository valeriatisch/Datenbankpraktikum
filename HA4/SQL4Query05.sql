-- Aufgabe 5:
-- areaUnderCurveSP
-- (siehe Folien)
--
-- Punkte:
-- 3
--

CREATE OR REPLACE PROCEDURE ComputeAreaUnderCurve()
BEGIN
    DECLARE x_prev_index DOUBLE;
    DECLARE y_prev_index DOUBLE;
    DECLARE A DOUBLE;
    DECLARE count INTEGER;
    FOR m AS
        SELECT series
        FROM Messungen
        GROUP BY series
        DO
            SET A = 0;
            SET count = 0;
            FOR n AS
                SELECT *
                FROM Messungen
                WHERE series = m.series
                ORDER BY x
                DO
                    BEGIN
                        SET count = count + 1;
                        IF(count > 1) THEN
                            SET A = A + (((n.x - x_prev_index)/2)*(n.y + y_prev_index));
                        END IF;
                        SET x_prev_index = n.x;
                        SET y_prev_index = n.y;
                    END;
            END FOR;
            INSERT INTO area_under_curve VALUES(m.series, A);
        END FOR;
END

CREATE OR REPLACE PROCEDURE ComputeAreaUnderCurve()
BEGIN
    DECLARE x_prev_index DOUBLE;
    DECLARE y_prev_index DOUBLE;
    DECLARE A DOUBLE;
    FOR m AS
        SELECT series
        FROM Messungen
        GROUP BY series
        DO
        SET A = 0;
            FOR n AS
                SELECT *
                FROM Messungen
                WHERE series = m.series
                ORDER BY x
                DO
                    BEGIN
                        IF (x_prev_index IS NULL) OR (y_prev_index IS NULL)
                        THEN SET x_prev_index = n.x;
                        SET y_prev_index = n.y;
                        ELSE SET A = A + (((n.x - x_prev_index)/2)*(n.y + y_prev_index));
                        SET x_prev_index = n.x;
                        SET y_prev_index = n.y;
                        END IF;
                    END;
                END FOR;
            BEGIN
                IF (SELECT COUNT(*) FROM area_under_curve WHERE m.series = series) = 0
                THEN UPDATE area_under_curve SET AREA=A WHERE series = m.series;
                ELSE INSERT INTO area_under_curve VALUES(m.series, A);
                END IF;
            END;
        END FOR;
END
-- 
-- SELECT id AS flight_id, name AS commander_name, pax_count FROM (
--     SELECT F.id, C.name
--     FROM Commander C
--     JOIN Flight F ON F.commander_id=C.id
--     WHERE F.date BETWEEN '2084-04-01' AND '2084-05-01'
--     AND C.name = _commander_name -- ) R
-- JOIN (
--     SELECT F.id, COUNT(P.id)::INT AS pax_count
--     FROM Flight F
--     JOIN Booking B ON B.flight_id = F.id
--     JOIN Pax P ON B.pax_id=P.id
--     WHERE P.race='Men'
--     GROUP BY F.id
-- ) T USING(id) WHERE T.pax_count>_pax_count;
DROP INDEX idx1;
DROP INDEX idx2;

EXPLAIN ANALYZE SELECT id AS flight_id, name AS commander_name, pax_count FROM (
    SELECT F.id, C.name
    FROM Commander C
    JOIN Flight F ON F.commander_id=C.id
    WHERE F.date BETWEEN '2084-04-01' AND '2084-05-01'
    AND C.name = 'Ким'
) R
JOIN (
    SELECT F.id, COUNT(P.id)::INT AS pax_count
    FROM Flight F
    JOIN Booking B ON B.flight_id = F.id
    JOIN Pax P ON B.pax_id=P.id
    WHERE P.race='Men'
    GROUP BY F.id
) T USING(id) WHERE T.pax_count>1;

EXPLAIN ANALYZE SELECT F.id AS flight_id, C.name AS commander_name, COUNT(P.id) AS pax_count
  FROM Commander C 
  JOIN Flight F ON F.commander_id = C.id
  JOIN Booking B ON B.flight_id = F.id
  JOIN Pax P ON B.pax_id = P.id
  WHERE F.date BETWEEN '2084-04-01' AND '2084-05-01'
        AND P.race = 'Men'
        AND C.name = 'Ким'
  GROUP BY F.id, C.name
  HAVING COUNT(P.id) > 1;

CREATE INDEX idx1 ON Booking(flight_id);
CREATE INDEX idx2 ON Flight(commander_id);

EXPLAIN ANALYZE SELECT F.id AS flight_id, C.name AS commander_name, COUNT(P.id)::INT AS pax_count
  FROM Commander C 
  JOIN Flight F ON F.commander_id = C.id
  JOIN Booking B ON B.flight_id = F.id
  JOIN Pax P ON B.pax_id = P.id
  WHERE F.date BETWEEN '2084-04-01' AND '2084-05-01'
        AND P.race = 'Men'
        AND C.name = 'Ким'
  GROUP BY F.id, C.name
  HAVING COUNT(P.id) > 1;


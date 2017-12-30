-- Здесь можно сделать что-нибудь до начала теста
-- CREATE INDEX idx1 ON Commander(name);
-- CREATE INDEX idx_planet ON Planet(name);
DROP INDEX idx_book;
DROP INDEX idx_scid;
DROP INDEX idx_plid;
---------------------------------------------------------- 
-- Запрос будет получать параметры _planet_name и _capacity
EXPLAIN ANALYZE SELECT COUNT(1)
FROM Flight F JOIN Spacecraft S ON F.spacecraft_id = S.id
JOIN Planet P ON F.planet_id = P.id
JOIN Booking B ON F.id = B.flight_id
WHERE 
  S.capacity<30 
  AND S.class=1
  AND P.name='Azaqu';

CREATE INDEX idx_book ON Booking(flight_id);
CREATE INDEX idx_scid ON Flight(spacecraft_id);

EXPLAIN ANALYZE VERBOSE SELECT COUNT(1)
FROM Flight F JOIN Spacecraft S ON F.spacecraft_id = S.id
JOIN Planet P ON F.planet_id = P.id
JOIN Booking B ON F.id = B.flight_id
WHERE 
  S.capacity<30 
  AND S.class=1
  AND P.name='Azaqu';

DROP INDEX idx_scid;
CREATE INDEX idx_plid ON Flight(planet_id);

EXPLAIN ANALYZE VERBOSE SELECT COUNT(1)
FROM Flight F JOIN Spacecraft S ON F.spacecraft_id = S.id
JOIN Planet P ON F.planet_id = P.id
JOIN Booking B ON F.id = B.flight_id
WHERE 
  S.capacity<30 
  AND S.class=1
  AND P.name='Azaqu';

# Type your query above this line.

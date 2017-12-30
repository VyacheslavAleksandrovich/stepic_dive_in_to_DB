-- Вспомогательная функция, считающая количество пассажиров, летевших 
-- на планету _planet_id в звездолете класса _class

CREATE OR REPLACE FUNCTION GetPaxCount(_planet_id INT, _class INT) RETURNS BIGINT AS $$
SELECT COUNT(Pax.id)
FROM Planet P 
JOIN Flight F     ON P.id=F.planet_id
JOIN Booking B    ON B.flight_id = F.id
JOIN Spacecraft S ON F.spacecraft_id = S.id
JOIN Pax          ON B.pax_id = Pax.id
WHERE S.class = _class AND P.id = _planet_id;
$$ LANGUAGE SQL;

-- здесь можно создавать индексы, если угодно 
-- CREATE INDEX idx1 ON Commander(name);
-- CREATE INDEX idx1 ON Flight(planet_id);
-- CREATE INDEX idx2 ON Booking(flight_id);
-- CREATE INDEX idx3 ON Flight(spacecraft_id);
-- DROP INDEX idx1;
-- DROP INDEX idx2;
-- DROP INDEX idx3;

---- Запрос, нуждающийся в ускорении. 
-- Названия и типы возвращаемых столбцов:
-- TABLE(planet_id INT, spacecraft_class INT, takings BIGINT)

-- EXPLAIN ANALYZE SELECT COUNT(Pax.id)
-- FROM Planet P 
-- JOIN Flight F     ON P.id=F.planet_id
-- JOIN Booking B    ON B.flight_id = F.id
-- JOIN Spacecraft S ON F.spacecraft_id = S.id
-- JOIN Pax          ON B.pax_id = Pax.id
-- WHERE S.class = 1 AND P.id = 1;

-- EXPLAIN ANALYZE SELECT Price.planet_id, 
--         Price.spacecraft_class, 
--         Price.price * GetPaxCount(Price.planet_id, Price.spacecraft_class) FROM Price;

-- CREATE INDEX idx1 ON Flight(planet_id);
-- CREATE INDEX idx2 ON Booking(flight_id);
-- CREATE INDEX idx3 ON Flight(spacecraft_id);
--CREATE INDEX idx4 ON Booking(pax_id);

-- EXPLAIN ANALYZE VERBOSE SELECT COUNT(Pax.id)
-- FROM Planet P 
-- JOIN Flight F     ON P.id=F.planet_id
-- JOIN Booking B    ON B.flight_id = F.id
-- JOIN Spacecraft S ON F.spacecraft_id = S.id
-- JOIN Pax          ON B.pax_id = Pax.id
-- WHERE S.class = 1 AND P.id = 1;

EXPLAIN ANALYZE SELECT Pr.planet_id, Pr.spacecraft_class, Pr.price * COUNT(Pax.id) FROM Price Pr
JOIN Planet P     ON Pr.planet_id = P.id
JOIN Flight F     ON P.id = F.planet_id
JOIN Booking B    ON B.flight_id = F.id
JOIN Spacecraft S ON F.spacecraft_id = S.id AND S.class = Pr.spacecraft_class
JOIN Pax          ON B.pax_id = Pax.id
GROUP BY PR.planet_id, Pr.spacecraft_class, Pr.price;

EXPLAIN ANALYZE SELECT Price.planet_id, 
        Price.spacecraft_class, 
        Price.price * GetPaxCount(Price.planet_id, Price.spacecraft_class) FROM Price;

# Type your query above this line.

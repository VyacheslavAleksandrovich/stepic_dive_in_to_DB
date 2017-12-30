DROP TABLE IF EXISTS Flight;
DROP TABLE IF EXISTS Planet;
DROP TABLE IF EXISTS PoliticalSystem;

-- Справочник политических строев
CREATE TABLE PoliticalSystem(
  id SERIAL PRIMARY KEY, 
  value TEXT UNIQUE);

-- Планета, её название, расстояние до Земли, политический строй
CREATE TABLE Planet(
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE,
  distance NUMERIC(5,2),
  psystem_id INT REFERENCES PoliticalSystem);

-- Полет на планету в означенную дату
CREATE TABLE Flight(
  id INT PRIMARY KEY,
  planet_id INT REFERENCES Planet,
  date DATE
);

INSERT INTO PoliticalSystem
VALUES (1, 'демократия'),
       (2, 'диктатура'),
       (3, 'равенство');
INSERT INTO Planet
VALUES (1, 'Земля', 1.22, 1),
       (2, 'Марс', 2.44, 2),
       (3, 'Юпитер', 12.44, 3),
       (4, 'Венера', 31, 3),
       (5, 'Луна', 31, 3);
INSERT INTO Flight
VALUES (1, 1, date('2012-01-05')),
       (2, 2, date('2012-01-05')),
       (3, 3, date('2012-01-05')),
       (4, 4, date('2012-01-05')),
       (5, 1, date('2012-01-06')),
       (6, 2, date('2012-01-06')),
       (7, 4, date('2012-01-06')),
       (8, 1, date('2012-01-07')),
       (9, 3, date('2012-01-07')),
       (10, 4, date('2012-01-07')),
       (11, 1, date('2012-01-08')),
       (12, 2, date('2012-01-08')),
       (13, 4, date('2012-01-08')),
       (14, 2, date('2012-01-09')),
       (15, 4, date('2012-01-09')),
       (16, 1, date('2012-01-10')),
       (17, 2, date('2012-01-10')),
       (18, 3, date('2012-01-10')),
       (19, 4, date('2012-01-10'));

WITH planet_flight_political AS (
  SELECT P.name as planet, PS.value as psystem, count(F.id) as n_fly 
    FROM Planet P
    LEFT JOIN Flight F ON P.id = F.planet_id
    JOIN PoliticalSystem PS ON P.psystem_id = PS.id
    GROUP BY P.name, PS.value)
SELECT planet, 
       psystem, 
       rank() OVER (
        PARTITION BY psystem ORDER BY n_fly DESC) as local_rank,
       rank() OVER (ORDER BY n_fly DESC) as global_rank
       FROM planet_flight_political ORDER BY n_fly DESC;

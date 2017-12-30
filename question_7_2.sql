DROP TABLE  IF EXISTS Booking;
DROP TABLE  IF EXISTS Flight;
DROP TABLE  IF EXISTS Spacecraft;
DROP TABLE  IF EXISTS Planet;


CREATE TABLE Planet( 
  id SERIAL PRIMARY KEY,  
  name TEXT UNIQUE,  
  distance NUMERIC(5,2));

CREATE TABLE Spacecraft(
      id SERIAL PRIMARY KEY,
      name TEXT UNIQUE,
      service_life INT DEFAULT 1000,
      capacity INT DEFAULT 1,
      class INT DEFAULT 1
);

CREATE TABLE Flight(
      id INT PRIMARY KEY,
      spacecraft_id INT REFERENCES Spacecraft,
      planet_id INT REFERENCES Planet,
      start_date DATE
);

CREATE TABLE Booking(
      id SERIAL PRIMARY KEY,
      flight_id INT REFERENCES Flight
);


SELECT COUNT(1)
FROM Flight F JOIN Spacecraft S ON F.spacecraft_id = S.id
JOIN Planet P ON F.planet_id = P.id
JOIN Booking B ON F.id = B.flight_id
WHERE S.capacity<100 AND S.class=1
AND P.name='earth';

# Type your query above this line.

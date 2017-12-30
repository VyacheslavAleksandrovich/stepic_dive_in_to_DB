-- Серия ежегодных конференций
DROP VIEW IF EXISTS HighPaperAcceptance;
DROP TABLE IF EXISTS Paper;
DROP TABLE IF EXISTS ConferenceEvent;
DROP TABLE IF EXISTS Conference;

CREATE TABLE Conference (
      id   INT PRIMARY KEY,
      name TEXT
);

-- "Событие" -- конференция в конкретном году

CREATE TABLE ConferenceEvent (
      id               INT PRIMARY KEY,
      conference_id    INT REFERENCES Conference,
      year             INT,
      total_papers     INT,
      accepted_papers  INT,
      acceptance_ratio NUMERIC(3, 2),
      UNIQUE (conference_id, year)
);

ALTER TABLE ConferenceEvent DROP COLUMN total_papers;
ALTER TABLE ConferenceEvent DROP COLUMN accepted_papers;
ALTER TABLE ConferenceEvent DROP COLUMN acceptance_ratio;

CREATE TABLE Paper(
      id INT PRIMARY KEY,
      event_id INT REFERENCES ConferenceEvent,
      title TEXT,
      accepted BOOLEAN);

INSERT INTO Conference VALUES (0, 'Canada con');
INSERT INTO Conference VALUES (1, 'Vancouver con');
INSERT INTO Conference VALUES (2, 'Glasgo con');
INSERT INTO ConferenceEvent VALUES (0, 0, 2000);
INSERT INTO ConferenceEvent VALUES (1, 1, 2000);
INSERT INTO ConferenceEvent VALUES (2, 2, 2001);
INSERT INTO Paper VALUES (0, 0, 'Грибы и всё всё всё', True);
INSERT INTO Paper VALUES (1, 0, 'Ответ на всё 42', True);
INSERT INTO Paper VALUES (2, 0, 'Ответ на всё 43', False);
INSERT INTO Paper VALUES (3, 1, 'Грибы и всё всё всё 2', True);
INSERT INTO Paper VALUES (4, 1, 'Ответ на всё 42 часть вторая', False);
INSERT INTO Paper VALUES (5, 1, 'Ответ на всё 43 часть треть', False);
INSERT INTO Paper VALUES (6, 2, 'Наше всё', True);
INSERT INTO Paper VALUES (7, 2, 'Наше всё 2', True);

CREATE VIEW HighPaperAcceptance AS
SELECT C.name, T.year, T.total_papers as total_papers, T.acceptance_ratio as acceptance_ratio FROM
    Conference C 
    JOIN 
    (SELECT CE.conference_id as CID,
        CE.year AS year, 
        COUNT(P.id) as total_papers, 
        (COALESCE(SUM(CASE WHEN P.accepted THEN 1::NUMERIC(3,2) ELSE 0::NUMERIC(3,2) END), 0::NUMERIC(3,2)) / COUNT(P.id))::NUMERIC(3,2) as acceptance_ratio
        FROM ConferenceEvent CE
        JOIN Paper P ON P.event_id = CE.id 
        GROUP BY CE.id) T
    ON C.ID = T.CID
    WHERE T.total_papers > 5 AND T.acceptance_ratio > 0.75

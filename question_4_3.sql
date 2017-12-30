DROP TABLE IF EXISTS PaperReviewing;
DROP TABLE IF EXISTS Reviewer;
DROP TABLE IF EXISTS Paper;
DROP TABLE IF EXISTS ConferenceEvent;
DROP TABLE IF EXISTS Conference;


CREATE TABLE Conference(
  id INT PRIMARY KEY, name TEXT UNIQUE);

CREATE TABLE ConferenceEvent(
  id SERIAL PRIMARY KEY,
	conference_id INT, -- REFERENCES Conference,
	year INT,
	UNIQUE(conference_id, year));

CREATE TABLE Paper(
  id INT PRIMARY KEY,
  event_id INT, -- REFERENCES ConferenceEvent,
  title TEXT,
  accepted BOOLEAN
);

CREATE TABLE Reviewer(
  id INT PRIMARY KEY,
  email TEXT UNIQUE,
  name TEXT
);

CREATE TABLE PaperReviewing(
  paper_id INT, -- REFERENCES Paper,
  reviewer_id INT, -- REFERENCES Reviewer,
  score INT,
  UNIQUE(paper_id, reviewer_id)
);

INSERT INTO Conference(id, name) VALUES (1, 'SIGMOD'), (2, 'VLDB');
INSERT INTO ConferenceEvent(conference_id, year) VALUES (1, 2015), (1, 2016), (2, 2016);
INSERT INTO Reviewer(id, email, name) VALUES
  (1, 'jennifer@stanford.edu', 'Jennifer Widom'),
  (2, 'donald@ethz.ch', 'Donald Kossmann'),
  (3, 'jeffrey@stanford.edu', 'Jeffrey Ullman'),
  (4, 'jeff@google.com', 'Jeffrey Dean'),
  (5, 'michael@mit.edu', 'Michael Stonebraker');

INSERT INTO Paper(id, event_id, title) VALUES
  (1, 1, 'Paper1'),
  (2, 2, 'Paper2'),
  (3, 2, 'Paper3'),
  (4, 3, 'Paper4');

INSERT INTO PaperReviewing(paper_id, reviewer_id) VALUES
  (1, 1), (1, 4), (1, 5),
  (2, 1), (2, 2), (2, 4),
  (3, 3), (3, 4), (3, 5),
  (4, 2), (4, 3), (4, 4);


CREATE OR REPLACE FUNCTION SubmitReview(_paper_id INT, _reviewer_id INT, _score INT)
  RETURNS VOID AS $$
    DECLARE 
      is_reviwed BOOLEAN;
      current_score INT;
      avg_score INT;
      count_review  INT;
      review_id INT;
    BEGIN
      SELECT accepted INTO STRICT is_reviwed
        FROM Paper WHERE id = _paper_id;
      -- SELECT score INTO STRICT current_score
      --   FROM PaperReviewing WHERE paper_id = _paper_id AND reviewer_id = _reviewer_id;
      IF (_score BETWEEN 1 AND 7) AND (is_reviwed IS NULL) THEN
        UPDATE PaperReviewing
          SET score = _score
          WHERE paper_id = _paper_id AND reviewer_id = _reviewer_id 
          RETURNING paper_id INTO STRICT review_id;
        SELECT count(score), avg(score) INTO count_review, avg_score FROM PaperReviewing
          WHERE paper_id = _paper_id;
        IF count_review = 3 THEN
--          RAISE NOTICE 'AVG score is (%)', avg_score;
          IF avg_score > 4 THEN
            UPDATE Paper
              SET accepted = TRUE
              WHERE id = _paper_id;
          ELSE
            UPDATE Paper
              SET accepted = FALSE
              WHERE id = _paper_id;
          END IF;
        END IF;
      ELSE
        RAISE SQLSTATE 'DB017';
      END IF;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN 
          RAISE SQLSTATE 'DB017';
    END;
$$ LANGUAGE plpgsql;


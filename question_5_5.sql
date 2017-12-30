DROP TABLE IF EXISTS StockQuotes;

CREATE TABLE StockQuotes (
  company TEXT,
  week INT,
  share_price INT);

INSERT INTO StockQuotes
VALUES 
        ('Apple',      1,  10),
        ('Apple',      2,  15),
        ('Apple',      3,  20),
        ('Apple',      4,  25),
        ('Apple',      5,  30),
        ('Apple',      6,  35),
        ('Apple',      7,  40),
        ('Apple',      8,  45),
        ('Apple',      9,  50),
        ('Apple',     10,  60),
        ('Apple',     11,  70),
        ('Apple',     12,  80),
        ('Apple',     13,  90),
        ('Apple',     14,  90),
        ('Apple',     15, 100),
        ('Apple',     16, 100),
        ('Apple',     17, 100),
        ('Apple',     18, 100),
        ('Apple',     19, 100),
        ('Apple',     20,  90),
        ('Oracle',     1,  10),
        ('Oracle',     2,  10),
        ('Oracle',     3,  10),
        ('Oracle',     4,  10),
        ('Oracle',     5,  10),
        ('Oracle',     6,  10),
        ('Oracle',     7,  10),
        ('Oracle',     8,  10),
        ('Oracle',     9,  10),
        ('Oracle',     10,  10),
        ('Oracle',     11,  10),
        ('Oracle',     12,  10),
        ('Oracle',     13,  10),
        ('Oracle',     14,  10),
        ('Oracle',     15,  10),
        ('Oracle',     16,  10),
        ('Oracle',     17,  10),
        ('Oracle',     18,  10),
        ('Oracle',     19,  10),
        ('Oracle',     20,  10),
        ('Microsoft',  1, 100),
        ('Microsoft',  2,  95),
        ('Microsoft',  3,  95),
        ('Microsoft',  4,  90),
        ('Microsoft',  5,  90),
        ('Microsoft',  6,  85),
        ('Microsoft',  7,  80),
        ('Microsoft',  8,  100),
        ('Microsoft',  9,  120),
        ('Microsoft',  10, 150),
        ('Microsoft',  11, 100),
        ('Microsoft',  12,  90),
        ('Microsoft',  13,  90),
        ('Microsoft',  14,  85),
        ('Microsoft',  15,  80),
        ('Microsoft',  16,  75),
        ('Microsoft',  17,  70),
        ('Microsoft',  18,  70),
        ('Microsoft',  19,  65),
        ('Microsoft',  20,  60);

WITH share_grow AS (
  SELECT SQ.company, SQ.week, SQ.share_price, 
    SQ.share_price - FIRST_VALUE(SQ.share_price) OVER (
      PARTITION BY SQ.company ORDER BY SQ.week ASC
      ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS delta
    FROM StockQuotes SQ),
  share_avg_delta AS (
    SELECT SG.company, SG.week, SG.share_price, SG.delta,
      AVG(SG.delta) OVER (
        PARTITION BY SG.week) as s_avg, 
      SG.delta > AVG(SG.delta) OVER (
        PARTITION BY SG.week) as is_succes
      FROM share_grow SG),
  zerro_week AS (
    SELECT SG.company, (min(SG.week) - 1) as week, 0 as share_price, 0 as delta, 0 as s_avg, FALSE as is_succes
      FROM share_grow SG
      GROUP BY SG.company),
  union_table AS (
    (SELECT * FROM zerro_week)
    UNION
    (SELECT * FROM share_avg_delta)),
  succes_company AS (
    SELECT SA.company, SA.week, SA.share_price, SA.delta, SA.is_succes,
      bool_and(SA.is_succes) OVER (
        PARTITION BY SA.company ORDER BY SA.week ASC
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS three_week_succ
      FROM union_table SA)

SELECT company, count(*) as succ_count
  FROM succes_company
  WHERE three_week_succ 
  GROUP BY company;

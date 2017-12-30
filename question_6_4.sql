select kw.id, kt.id from keywordltree kw LEFT JOIN keywordltree kt ON kw.id = 0 and kt.id = 1
where kw.id = 1;

WITH RECURSIVE 
  numerate_keyword AS (
    SELECT id, value, path, count(*)
    OVER (ORDER BY path) AS num_
    FROM keywordltree),
  iter_node AS (
    SELECT path, Array[path] AS path_, 1 AS uba, 2 AS next_num, 1 AS sn FROM numerate_keyword
    WHERE id = 0
    UNION ALL
    (WITH rkey AS (
      SELECT in_.path_ AS path_, 
             in_.uba AS uba,
             in_.next_num AS next_num, 
             in_.sn AS sn,
             kwt.path AS current_path,
             CASE 
              WHEN in_.path_[in_.uba] @> kwt.path THEN True ELSE False
             END AS is_pref,
             CASE 
              WHEN kwt.path is NULL THEN True ELSE False
             END AS null_path
      FROM iter_node in_
      LEFT JOIN numerate_keyword kwt ON kwt.num_ = in_.next_num
      WHERE array_length(in_.path_, 1) > 0)
    SELECT CASE WHEN null_path THEN path_[uba]
                WHEN is_pref THEN current_path
                ELSE path_[uba] END AS path,
           CASE WHEN is_pref THEN path_ || current_path 
                ELSE path_[0:uba-1] END AS path_,
           CASE WHEN is_pref THEN (uba + 1)
                ELSE (uba - 1) END AS uba,
           CASE WHEN is_pref THEN (next_num + 1)
                ELSE next_num END AS next_num,
           sn + 1 AS sn
          FROM rkey)),
  group_path AS (
    SELECT path, min(sn) :: BIGINT AS lft, max(sn) :: BIGINT AS rgt FROM iter_node
    GROUP BY path)
  select kw.id, kw.value, gp.lft, gp.rgt 
  FROM keywordltree kw
  JOIN group_path gp ON gp.path = kw.path
  ORDER BY kw.id;

# Type your query above this line.

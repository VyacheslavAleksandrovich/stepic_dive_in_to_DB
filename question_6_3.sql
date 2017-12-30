-- select id, unnest(value) from testarray;

-- SELECT * FROM Keyword;

WITH RECURSIVE keyword_nodes(id, node_count, current_parents) AS (
  SELECT id, 1::BIGINT as node_count, Array[id] as current_parents FROM Keyword
  UNION ALL
  (WITH kn_ AS (
    SELECT id, node_count, unnest(current_parents) as parent FROM keyword_nodes)
   SELECT kn.id, 
          (kn.node_count + count(kw.id)) AS node_count, 
          array_agg(kw.id) as current_parents 
          FROM kn_ kn
   JOIN 
   Keyword kw  ON kn.parent = kw.parent_id
   GROUP BY kn.id, kn.node_count))
SELECT id, max(node_count) AS subtree_size 
FROM keyword_nodes
GROUP BY id
ORDER BY id;

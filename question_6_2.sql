DROP TABLE IF EXISTS Cities;

CREATE TABLE Cities(
  id INT PRIMARY KEY,
  value TEXT);

    -- Пример данных
INSERT INTO Cities(id, value) VALUES 
  (0, 'Джамбул'), 
  (1, 'Воркута'), 
  (2, 'Львив'),
  (3, 'Львов'),
  (4, 'Алдан');

select right(lower('ВоркутA'), 1);
select Array[id] <@ Array[0,1] from Cities;

WITH RECURSIVE r_cities(id, value, serial_number, curr_path) AS (
  SELECT id, value, 0 as serial_number, Array[id] as curr_path FROM Cities
  WHERE id = 0
  UNION ALL
  (SELECT c.id, c.value, 
          r_c.serial_number + 1 AS serial_number, 
          array_append(r_c.curr_path, c.id)
  FROM
    Cities c
  JOIN 
    r_cities r_c ON right(lower(r_c.value),1) = left(lower(c.value), 1)
  WHERE not (Array[c.id] <@ r_c.curr_path)
  LIMIT 1)
)
SELECT id, value, serial_number as num from r_cities;

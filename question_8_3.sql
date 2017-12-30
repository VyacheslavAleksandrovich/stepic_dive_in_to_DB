WITH dino_planet_log AS (
  select name, wiki_jsonb -> 'log' as log from Planet
  where wiki_jsonb #>> '{features, dinosaurs}' = '1'),
dino_planet_rec AS (
  select name as planet_name, 
         jsonb_array_elements(log) ->> 'commander' as commander_name
  from dino_planet_log),
commanders_logs AS (  
  select c.id, jsonb_build_object('rating', c.rating,
                                  'selfies', jsonb_agg(jsonb_object('{planet, with}', ARRAY[planet_name, 'dino'])))
  from dino_planet_rec dr join commander c on dr.commander_name = c.name
  group by c.id, c.rating)
select * from commanders_logs;

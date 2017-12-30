drop table planet_w;

CREATE TABLE Planet_w(
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE,
  distance NUMERIC(5,2),
  government_id INT REFERENCES Government,
  wiki HSTORE);

insert into planet_w (name, distance, government_id, wiki)
values 
('aaa', 10.1, 1, 'danger=>1, dinosaurs=>1'),
('bbb', 10.2, 2, 'danger=>0'),
('xxx', 10.2, 2, 'sample=>3'),
('ccc', 10.3, 3, 'danger=>1, dinosaurs=>1'),
('pirat_planet', 10.4, 3, 'danger=>1, crime=>1, pirates=>1, weapons=>1'),
('ddd', 10.4, 4, 'danger=>1, weapons=>1');

with dangerous as (
  select  akeys(
            delete(
              slice(wiki, array['dinosaurs', 'weapons', 'pirates', 'earthquakes', 'crime', 'mosquitoes']),
              'dinosaurs=>0, weapons=>0, pirates=>0, earthquakes=>0, crime=>0, mosquitoes=>0'
              )
          ) as wiki, 
          1 as id
          from planet_w where ((wiki->'danger') = '1')
), unrol_dangerous as (
  select wiki from dangerous
)
select unnest(wiki) from dangerous ;

# Type your query above this line.

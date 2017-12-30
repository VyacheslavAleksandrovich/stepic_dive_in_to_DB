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
  select unnest(wiki) as danger from dangerous
), grouping_danger as (
  select danger as tag, count(danger) as count_ from unrol_dangerous
  group by danger
)
select tag, count_ as count from grouping_danger
where count_ = (select max(count_) from grouping_danger);



with T2 as (
  select value, 1 as num from T
  order by value
),
T3 AS (
  select t21.value, count(t22.num) as cnum from T2 t21, T2 t22
  where t21.value >= t22.value
  group by t21.value
),
T4 as (select max(cnum) as mc from T3)
select ttt.value, (ttt.cnum*2)-1 from T3 ttt
where ttt.cnum in (select mc/2 + 1 from T4)

select t.conf from 
    (select conference as conf ,count(distinct location) as loc from paper GROUP BY conference ) as t 
    WHERE t.loc > 1 
union 
select p.conference from paper p where p.location not in (select value from location)
union 
select p.conference from paper p where p.conference not in (select value from conference);

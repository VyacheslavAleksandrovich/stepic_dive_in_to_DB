select max(t.nflight) + count(t.pid) from (select p.id as pid, count(f.id) as nflight from planet p 
    join flight f ON f.planet_id = p.id
    where p.galaxy = 2
    group by p.id) t;

# Type your query above this line.

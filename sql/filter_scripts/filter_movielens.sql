DROP TABLE IF EXISTS movielens.filtered;
create table movielens.filtered as 
SELECT 
    t1."movieId" 
    , t1.title
    , concat_ws(',', t1.genre1
    , t1.genre2
    , t1.genre3
    , t1.genre4
    , t1.genre5
    , t1.genre6
    , t1.genre7
    , t1.genre8
    , t1.genre9
    , t1.genre10
    , t1.genre11) as genres
    , t1.year
    , t1.gem_rat as avg_rat
    , t1.amount
    , t2."events depicted" 
    , case when 'hitler' = any(string_to_array(lower(t2."events depicted"),' ')) 
    or 'second world war' = any(string_to_array(lower(t2."events depicted"),' ') )
    or '2nd world war' = any(string_to_array(lower(t2."events depicted"),' '))
    or 'nazi' = any(string_to_array(lower(t2."events depicted"),' '))
    or 'nazi germany' = any(string_to_array(lower(t2."events depicted"),' '))
    then 'second world war'
    when 'vietnam' = any(string_to_array(lower(t2."events depicted"),' ')) 
    or 'vietnam war' = any(string_to_array(lower(t2."events depicted"),' ')) 
    or 'guerilla' = any(string_to_array(lower(t2."events depicted"),' ')) 
    or 'vietcong' = any(string_to_array(lower(t2."events depicted"),' ')) 
    then 'Vietnam War'
	end as historical_event
FROM movielens.movies as t1
LEFT JOIN movielens.vietnam_movies as t2 on 
    t1."movieId" = t2."movieId" 

--also update some records which were classified as vietnam movies, based on the events depicted column 
update movielens.filtered 
set historical_event = 'Vietnam War'
where "events depicted" is not null;
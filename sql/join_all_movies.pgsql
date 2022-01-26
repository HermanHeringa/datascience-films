drop table A00_imdb;
create TEMP table A00_imdb as 
select t1."primaryTitle" 
, t1."startYear" as movie_release_year
, t2."date" as event_year
, t2."EVENTID" 
, t1.genres 
, t2."SUMMARY" 
, t1.plot 
, t1."numVotes" 
, t1."averageRating" 
, t2."COUNTRY" 
, t2."CITY" 
, t1.historical_event
from imdb.filtered as t1 
join data.news as t2 on 
date_part('year',t2."date") between t1."startYear" - 1 and "startYear" 
and string_to_array(t2."SUMMARY",' ') && string_to_array(plot,' ')
and (t2."TARGET1" = any(string_to_array(t1.plot,' '))
or t2."COUNTRY" = any(string_to_array(t1.plot,' '))
or t2."CITY" = any(string_to_array(t1.plot,' '))
or t2."ACTOR1" = any(string_to_array(t1.plot,' ')))
where 'War' = any(string_to_array(genres,',')) 
or 'Documentary' = any(string_to_array(genres,',')) 

select count(*) from A00_imdb

create TEMP table B00_movielens as 
select t1.title
, t1.year as movie_release_year
, t2."date" as event_year
, t2."EVENTID" 
, t1.genres 
, t2."SUMMARY" 
, t1."events depicted" 
, t1.amount
, t1.avg_rat
, t2."COUNTRY" 
, t2."CITY" 
, t1.historical_event
from movielens.filtered as t1 
join data.news as t2 on 
date_part('year',t2."date") between t1."year" - 1 and "year" 
and string_to_array(t2."SUMMARY",' ') && string_to_array("events depicted" ,' ')
and (t2."TARGET1" = any(string_to_array(t1."events depicted" ,' '))
or t2."COUNTRY" = any(string_to_array(t1."events depicted" ,' '))
or t2."CITY" = any(string_to_array(t1."events depicted" ,' '))
or t2."ACTOR1" = any(string_to_array(t1."events depicted" ,' ')))
where 'War' = any(string_to_array(genres,',')) 
or 'Documentary' = any(string_to_array(genres,',')) 


select count(*) from B00_movielens

create TEMP table C00_kaggle as 
select 
t1.title
, t1.movie_release_year
, t2."date" as event_year
, t2."EVENTID" 
, t1.genres 
, t2."SUMMARY" 
, t1.plot 
, t1.vote_count
, t1.vote_average
, t2."COUNTRY" 
, t2."CITY" 
, t1.historical_event
from kaggle.filtered as t1 
join data.news as t2 on 
date_part('year',t2."date") between t1.movie_release_year - 1 and t1.movie_release_year 
and string_to_array(t2."SUMMARY",' ') && string_to_array("plot" ,' ')
and (t2."TARGET1" = any(string_to_array(t1."plot" ,' '))
or t2."COUNTRY" = any(string_to_array(t1."plot" ,' '))
or t2."CITY" = any(string_to_array(t1."plot" ,' '))
or t2."ACTOR1" = any(string_to_array(t1."plot" ,' ')))
where 'War' = any(string_to_array(genres,',')) 
or 'Documentary' = any(string_to_array(genres,',')) 

create table data.joined_war as 
select * from A00_imdb
union all 
select * from B00_movielens
union all 
select * from C00_kaggle
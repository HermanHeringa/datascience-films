create table kaggle.filtered as
select 
    title
    , date_part('year', release_date::date) as movie_release_year
    , genres 
    , overview as plot 
    , vote_count 
    , vote_average 
from kaggle.raw 




    create TEMP table C00_imdb as 
select t1."primaryTitle" 
, t1."startYear" as movie_release_year
, t2."date" as event_year
, t2."EVENTID" 
, t1.genres 
, t2."SUMMARY" 
, t1.plot 
, t1."numVotes" 
, t1."averageRating" 
, t1.historical_event 
, t2."COUNTRY" 
, t2."CITY" 
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

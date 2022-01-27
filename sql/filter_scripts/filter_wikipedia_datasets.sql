/*
Join the data from wikipedia on the movielens and imdb datasets to see if there are matches
The data from wikipedia consists of world war 2 movies. 
*/

--949 matches on the imdb dataset
drop table if exists wikipedia.filtered_imdb;
create table wikipedia.filtered_imdb as 
select distinct on (t2."primaryTitle") t2.*, t1.events_depicted 
from wikipedia.joined_ww2_movies_raw as t1 
join imdb.movies as t2 on 
lower(t1.main_title) = lower(t2."primaryTitle")
and t1.movie_release_year = t2."startYear" 
where t2."titleType" = 'movie';

/* the imdb matched data should be joined on the imdb.filtered data so we 
filter out duplicate values 
*/

create table imdb.filtered_movies_w_wikipedia as 
select t1.* from imdb.filtered as t1 
left join wikipedia.filtered_imdb as t2 on 
t1.tconst = t2.tconst 
where t2.tconst is null 
union select 
tconst
, "titleType" 
, "primaryTitle" 
, "startYear" 
, "averageRating" 
, "numVotes" 
, genres 
, events_depicted as plot 
, historical_event 
from 
wikipedia.filtered_imdb;

drop table if exists wikipedia.filtered_imdb;
create table wikipedia.filtered_imdb as 
select distinct on (t2."primaryTitle") t2.*, t1.events_depicted 
from wikipedia.joined_ww2_movies_raw as t1 
join imdb.movies as t2 on 
lower(t1.main_title) = lower(t2."primaryTitle")
and t1.movie_release_year = t2."startYear" 
where t2."titleType" = 'movie';


--nothing on movielens sadly 
select distinct on (t2."title") t2.*
from wikipedia.joined_ww2_movies_raw as t1 
join movielens.movies as t2 on 
lower(t1.main_title) = lower(t2.title)
and t1.movie_release_year = t2."year" 

--63 on kaggle, need to join these to filter out duplicates
select distinct on (t2."title") t2.*
from wikipedia.joined_ww2_movies_raw as t1 
join kaggle.filtered as t2 on 
lower(t1.main_title) = lower(t2.title)
and t1.movie_release_year = t2.movie_release_year 
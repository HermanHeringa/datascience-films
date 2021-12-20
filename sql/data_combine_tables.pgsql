	CREATE TABLE data.genre_labels(
    id SERIAL,
	genre varchar
);
	
	
	create table data.non_historical as 
	select t1."primaryTitle" 
	, t1."startYear" as movie_release_year
	, t2."date" as event_year
	, t2."EVENTID" 
	, t1.genres 
	, t2."SUMMARY" 
	, t1.genre
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
	where t1.historical_event is null 
	

	create TEMP table A00_historical_imdb as 
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
	where t1.historical_event is not null 

	create temp table A05_joined_labels as 
	select t1."primaryTitle" 
	, t1.movie_release_year
	, t1.event_year
	, t1."EVENTID" 
	, t2.id as genre_label
	, t1."SUMMARY" 
	, t1.plot 
	, t1."numVotes" 
	, t1."averageRating" 
	, t1.historical_event 
	, t1."COUNTRY" 
	, t1."CITY" 
	from A00_historical_imdb as t1
	join data.genre_labels as t2 on 
	split_part(t1.genres,',',1) = t2.genre 
	

	create TEMP table B00_historical_movielens as 
	select t1.title
	, t1.year as movie_release_year
	, t2."date" as event_year
	, t2."EVENTID" 
	, t1.genres 
	, t2."SUMMARY" 
	, t1."events depicted" 
	, t1.amount
	, t1.avg_rat
	, 'vietnam war' as historical_event
	, t2."COUNTRY" 
	, t2."CITY" 
	from movielens.vietnam_movies as t1 
	join data.news as t2 on 
	date_part('year',t2."date") between t1."year" - 1 and "year" 
	and string_to_array(t2."SUMMARY",' ') && string_to_array("events depicted" ,' ')
	and (t2."TARGET1" = any(string_to_array(t1."events depicted" ,' '))
	or t2."COUNTRY" = any(string_to_array(t1."events depicted" ,' '))
	or t2."CITY" = any(string_to_array(t1."events depicted" ,' '))
	or t2."ACTOR1" = any(string_to_array(t1."events depicted" ,' ')))
	
	create temp table B05_joined_labels as
	select t1.title 
	, t1.movie_release_year
	, t1.event_year
	, t1."EVENTID" 
	, t2.id as genre_label
	, t1."SUMMARY" 
	, t1."events depicted" 
	, t1."amount" 
	, t1."avg_rat" 
	, t1.historical_event 
	, t1."COUNTRY" 
	, t1."CITY" 
	from B00_historical_movielens as t1
	join data.genre_labels as t2 on 
	split_part(t1.genres,'|',1) = t2.genre 

	drop table if exists data.historical;
	create table data.historical as 
	select * from A05_joined_labels
	UNION ALL 
	select * from B05_joined_labels;

	and (lower("TARGET1") like 'viet%'
	or lower("TARGET1") like 'usa'
	or lower("TARGET1") like 'united%'
	or lower("TARGET1") like 'holland'
	or lower("TARGET1") like '%netherland%'
	or lower("TARGET1") like '%states%'
	or lower("TARGET1") like '%france%'
	or lower("TARGET1") like '%soviet%'
	or lower("TARGET1") like '%chin%'
	or lower("TARGET1") like '%korea%')
	
	
	select distinct "TARGET1" from "data".news 
	
	select distinct "TARGET1" from "data".news 
	where lower("TARGET1") like 'viet%'
	or lower("TARGET1") like '%states%'
   
   select string_to_array(plot,' ')
   from imdb.filtered as t1 
   join data.news as t2 on 
   date_part('year',t2."date") between t1."startYear" - 1 and "startYear" 
   where string_to_array(t2."SUMMARY",' ') && string_to_array(plot,' ')
   
   
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
	from imdb.filtered as t1 
	join data.news as t2 on 
	date_part('year',t2."date") between t1."startYear" - 1 and "startYear" 
	and 
	
	
	
	select string_to_array('a v c d',' ') 
	where string_to_array('a b c d',' ') && string_to_array('a b c d e',' ')
	
	
	select ARRAY[3,4,1] && ARRAY[2,1]
	
	
	
	
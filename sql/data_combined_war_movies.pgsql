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
    where 'War' = any(string_to_array(genres,',')) 
    or 'Documentary' = any(string_to_array(genres,',')) 

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
	where 'War' = any(string_to_array(genres,',')) 
    or 'Documentary' = any(string_to_array(genres,',')) 

    drop table if exists data.historical_war_movies;
	create table data.historical_war_movies as 
	select * from A00_historical_imdb
	UNION ALL 
	select * from B00_historical_movielens;
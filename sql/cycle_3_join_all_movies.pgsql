
/* 
This SQL script joins the cleaned movie data with the data.news table 
data.news contains:
- USD data 
- GDELT data  

Just a sidenote, these sql operartions are CPU heavy, so expect your laptop to blow up :)
*/

CREATE OR REPLACE PROCEDURE data.join_news_movies() as $$

BEGIN

    raise notice 'Combining imdb dataset with data.news..';
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
    , CASE WHEN t1.historical_event = 'Second World War' then movie_release_year::int - 1945
    WHEN t1.historical_event = 'Vietnam War' then movie_release_year::int - 1975
    else null
    END AS years_after_event
    from imdb.filtered_movies_w_wikipedia as t1 
    join data.news as t2 on 
    date_part('year',t2."date") between t1."startYear" - 1 and "startYear" 
    and string_to_array(t2."SUMMARY",' ') && string_to_array(plot,' ')
    and (t2."TARGET1" = any(string_to_array(t1.plot,' '))
    or t2."COUNTRY" = any(string_to_array(t1.plot,' '))
    or t2."CITY" = any(string_to_array(t1.plot,' '))
    or t2."ACTOR1" = any(string_to_array(t1.plot,' ')));

    raise notice 'Combining movielens dataset with data.news..';
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
    , CASE WHEN t1.historical_event = 'Second World War' then movie_release_year::int - 1945
    WHEN t1.historical_event = 'Vietnam War' then movie_release_year::int - 1975
    else  null
    END AS years_after_event
    from movielens.filtered as t1 
    join data.news as t2 on 
    date_part('year',t2."date") between t1."year" - 1 and "year" 
    and string_to_array(t2."SUMMARY",' ') && string_to_array("events depicted" ,' ')
    and (t2."TARGET1" = any(string_to_array(t1."events depicted" ,' '))
    or t2."COUNTRY" = any(string_to_array(t1."events depicted" ,' '))
    or t2."CITY" = any(string_to_array(t1."events depicted" ,' '))
    or t2."ACTOR1" = any(string_to_array(t1."events depicted" ,' ')));

    raise notice 'Creating data.movies table.';
    drop table if exists data.movies;
    create table data.movies as 
    select * from A00_imdb
    union all 
    select * from B00_movielens;

END;
$$ LANGUAGE PLPGSQL;
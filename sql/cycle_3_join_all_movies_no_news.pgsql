
/* 
This SQL script joins the cleaned movie data with the data.news table 
data.news contains:
- USD data 
- GDELT data  

Just a sidenote, these sql operartions are CPU heavy, so expect your laptop to blow up :)
*/

CREATE OR REPLACE PROCEDURE data.join_news_movies_no_news() as $$

BEGIN

    raise notice 'imdb....';
    create TEMP table A00_imdb as 
    select t1."primaryTitle" 
    , t1."startYear" as movie_release_year
    , t1.genres 
    , t1.plot 
    , t1."numVotes" 
    , t1."averageRating" 
    , t1.historical_event
    , CASE WHEN t1.historical_event = 'Second World War' then t1."startYear"::int - 1945
    WHEN t1.historical_event = 'Vietnam War' then t1."startYear"::int - 1975
    else null
    END AS years_after_event
    from imdb.filtered_movies_w_wikipedia as t1;

    raise notice 'Movielens....';
    create TEMP table B00_movielens as 
    select t1.title
    , t1.year as movie_release_year
    , t1.genres 
    , t1."events depicted" 
    , t1.amount
    , t1.avg_rat
    , t1.historical_event
    , CASE WHEN t1.historical_event = 'Second World War' then t1.year::int - 1945
    WHEN t1.historical_event = 'Vietnam War' then t1.year::int - 1975
    else  null
    END AS years_after_event
    from movielens.filtered as t1;

    raise notice 'Creating data.movies_no_news table.';
    drop table if exists data.movies_no_news;
    create table data.movies_no_news as 
    select * from A00_imdb
    union all 
    select * from B00_movielens;

END;
$$ LANGUAGE PLPGSQL;
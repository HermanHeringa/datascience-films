
create or replace procedure data.filter_gdelt_imdb_war_movies()
as $$


BEGIN
    CREATE TEMP TABLE A00_gdelt_filtered as 
    select
    'v1' as source_table,
    *
    from gdelt.filtered_v1
    union 
    select 
    'v2' as source_table,
    id::bigint
    , date 
    , origin_name 
    , origin_country 
    , origin_place 
    , target_name 
    , target_country 
    , target_place 
    , eventcode
    , event_main_reason
    , cooperation_type 
    , goldsteinscale 
    , average_impact 
    , number_of_mentions 
    ,number_of_sources 
    from gdelt.filtered ;
	
    
    select * from A00_gdelt_filtered
    
    --filter only the extremes, these are big events 
    create temp table A05_gdelt_extremes as
	select * from A00_gdelt_filtered
	where "GoldsteinScale" >= 8 
	or "GoldsteinScale" <= -8;
   	
    CREATE TEMP TABLE B00_imdb_filtered as
        SELECT * from 
        imdb.filtered 
    WHERE 'War' = any(string_to_array(genres,',')) 
    OR 'Documentary' = any(string_to_array(genres,','));
	
   select * from B00_imdb_filtered

    CREATE  TABLE data AS 
    SELECT 
    * 
    from A00_gdelt_filtered as t1 
    join B00_imdb_filtered as t2 on 
    date_part('year', t1.date_recorded) between t2."startYear" - 5 and t2."startYear" + 1 



END;


$$ language plpgsql;

call gdelt.filter_events();
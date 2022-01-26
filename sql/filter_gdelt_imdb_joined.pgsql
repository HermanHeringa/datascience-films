CREATE TABLE data.joined (

)


create or replace procedure data.filter_gdelt_imdb()
as $$


BEGIN
    CREATE TEMP TABLE A00_gdelt_filtered as 
    select
    'v1' as source_table,
    *
    from gdelt.filtered_v1
    where target_country = 'VNM'
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
    from gdelt.filtered 
    where target_country = 'VNM'
	
   	
	
	
    CREATE TEMP TABLE B00_imdb_filtered as
    SELECT
    *
    FROM imdb.filtered
    where historical_event = 'vietnam war'
	
   select * from B00_imdb_filtered

    CREATE TEMP TABLE C00_JOINED_IMDB_GDELT AS 
    SELECT 
    * 
    from A00_gdelt_filtered as t1 
    join B00_imdb_filtered as t2 on 
    date_part('year', t1.date_recorded) between t2."startYear" - 5 and t2."startYear" + 1 
    
    




END;


$$ language plpgsql;

call gdelt.filter_events();
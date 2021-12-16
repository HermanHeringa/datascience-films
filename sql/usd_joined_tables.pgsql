create or replace procedure usd.join_tables() as $$

begin 
	
	raise notice 'Gathering usd data...';
	create temp table A00_selection as 
	select 
	'usd' as source_table
	, t1."EVENTID" 
	, t2."CITY_ID" 
	, t3."REPORTID" 
	, t2."CITY" 
	, t1."COUNTRY" 
	, CONCAT(t1."EYEAR"::int ,'-', t1."EMONTH"::int, '-', t1."EDAY"::int)::date as date
	, t1."ACTOR1" 
	, t1."ACTOR2" 
	, t1."ACTOR3" 
	, t1."TARGET1" 
	, t1."TARGET2" 
	, t1."SUMMARY" 
	from usd.events as t1 
	join usd.cities as t2 on 
	t1."CITY_ID" = t2."CITY_ID" 
	join usd.reports as t3 on 
	t1."REPORTID1" = t3."REPORTID"
	where case 
		when t1."EMONTH" = 1 then t1."EDAY"  <= 31
		when t1."EMONTH" = 2 then t1."EDAY"  <= 28
		when t1."EMONTH" = 3 then t1."EDAY"  <= 31
		when t1."EMONTH" = 4 then t1."EDAY"  <= 30
		when t1."EMONTH" = 5 then t1."EDAY"  <= 31
		when t1."EMONTH" = 6 then t1."EDAY"  <= 30
		when t1."EMONTH" = 7 then t1."EDAY"  <= 31
		when t1."EMONTH" = 8 then t1."EDAY"  <= 31
		when t1."EMONTH" = 9 then t1."EDAY"  <= 30
		when t1."EMONTH" = 10 then t1."EDAY"  <= 31
		when t1."EMONTH" = 11 then t1."EDAY"  <= 30
		when t1."EMONTH" = 12 then t1."EDAY"  <= 31
	end;


	raise notice 'Gathering gdelt data...';
	create temp table A00_joined_gdelt as 
    select
    'gdelt_v1' as source_table,
    *
    from gdelt.filtered_v1
    where target_country = 'VNM'
    union 
    select 
    'gdelt_v2' as source_table
    , id::bigint as EVENTID
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
    where target_country = 'VNM';


	raise notice 'Combining usd and gdelt data...';
	create temp table B00_filter as
	select 
	source_table
	, "EVENTID" 
	, "CITY_ID" 
	, "REPORTID" 
	, "CITY" 
	, "COUNTRY" 
	, date
	, "ACTOR1" 
	, "ACTOR2" 
	, "ACTOR3" 
	, "TARGET1" 
	, "TARGET2" 
	, "SUMMARY" 
	, NULL AS EVENT_MAIN_REASON
	, NULL AS COOPRORATION_TYPE
	, NULL AS GOLDSTEINSCALE
	, NULL AS AVERAGE_IMPACT
	, NULL AS NUMBER_OF_MENTIONS
	, NULL AS NUMBER_OF_SOURCES
	from A00_selection
	UNION ALL 
	SELECT 
	source_table
    , id::text as EVENTID
	, null as CITY_ID
	, null as REPORTID
	, target_place as CITY
    , target_country as COUNTRY
	, date_recorded as date
	, null as ACTOR1
	, NULL AS ACTOR2
	, NULL AS ACTOR3
    , target_name as TARGET1
	, NULL AS TARGET2
	, NULL AS SUMMARY
    , "CAMEOCodeDescription"
    , cooperation_type 
    , "GoldsteinScale" 
    , average_impact 
    , number_of_mentions 
    ,number_of_sources
	from A00_joined_gdelt;
	
	drop table if exists data.news;
	create table data.news (like B00_filter);

	insert into data.news 
	select * from B00_filter;
	
end;
$$ language PLPGSQL;
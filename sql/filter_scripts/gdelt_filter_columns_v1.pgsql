
/*
This SQL code is used to filter through the gdelt v1.0 tables
*/



create or replace procedure gdelt.filter_events_v1()
as $$

BEGIN
	
	--filtering on v1 table
	create temp table a00_filter_columns on commit drop as 
	select
	GLOBALEVENTID as id
	, to_date(SQLDATE
		, 'YYYYMMDD') as date
		, Actor1Name as origin_name
		, Actor1Countrycode as origin_country
		, Actor1Geo_FullName as origin_place
		, Actor2Name as target_name
		, Actor2Countrycode as target_country
		, Actor2Geo_FullName as target_place
		, EventCode
		, CAMECODESDescription
		, GoldsteinScale
		, AvgTone as average_impact
	from gdelt."events_v1";

	DROP TABLE IF EXISTS gdelt.joined_v1;
	CREATE TABLE gdelt.joined AS
	select * from a00_filter_columns;

	drop table if exists gdelt.categories_v1;
	create table gdelt.categories AS 
	select distinct split_part(unnest(string_to_array("V2ENHANCEDTHEMES",';')),',',1) as theme_categories
    from gdelt.joined;
end;
$$ language plpgsql;

call gdelt.filter_events_v1();
create or replace procedure gdelt.filter_events()
as $$

BEGIN
	
	--filtering
	create temp table a00_filter_columns on commit drop as 
	select
	id
	, to_date(concat( year::text
		, substr(day::text,5,2)
		, substr(day::text,7,2) )
		, 'YYYYMMDD') as date
		, actor1name as origin_name
		, actor1countrycode as origin_country
		, actor1geo_fullname as origin_place
		, actor2name as target_name
		, actor2countrycode as target_country
		, actor2geo_fullname as target_place
		, eventcode
		, case 
			when eventcode like '01%' then 'MAKE PUBLIC STATEMENT'
			when eventcode like '02%' then'APPEAL'
			when eventcode like '03%' then 'EXPRESS INTENT TO COOPERATE'
			when eventcode like '04%' then 'CONSULT/VISIT'
			when eventcode like '05%' then 'ENGAGE IN DIPLOMATIC COOPERATION'
			when eventcode like '06%' then 'ENGAGE IN MATERIAL COOPERATION'
			when eventcode like '07%' then 'PROVIDE AID'
			when eventcode like '08%' then 'YIELD/EASE/ACCEDE'
			when eventcode like '09%' then 'INVESTIGATE'
			when eventcode like '10%' then 'DEMAND'
			when eventcode like '11%' then 'DISAPPROVE'
			when eventcode like '12%' then 'REJECT'
			when eventcode like '13%' then 'THREATEN'
			when eventcode like '14%' then 'PROTEST'
			when eventcode like '15%' then 'EXHIBIT MILITARY POSTURE'
			when eventcode like '16%' then 'REDUCE RELATIONS'
			when eventcode like '17%' then 'COERCE'
			when eventcode like '18%' then 'ASSAULT'
			when eventcode like '19%' then 'FIGHT'
			when eventcode like '20%' then 'ENGAGE IN UNCONVENTIONAL MASS VIOLENCE'
		end as event_main_reason
		, case 
			when QuadClass::int =1 then 'Verbal Cooperation'
			when QuadClass::int = 2 then 'Material Cooperation'
			when QuadClass::int =3 then  'Verbal Conflict'
			when QuadClass::int = 4 then  'Material Conflict'
		end as cooperation_type
		, goldsteinscale
		, avgtone as average_impact
		, nummentions as number_of_mentions
		, numsources as number_of_sources
		, sourceurl
	from gdelt."event";
	

	-- insert filtered  event columns into filtered
	create temp table A0_FILTERED as 
	select * from a00_filter_columns;
	

	-- filter knowledge graph data and join with filtered 
	create temp table B00_filter_knowledge AS
	select 
	t1.*
	, t2."V2ENHANCEDTHEMES"
	, t2."V2ENHANCEDLOCATIONS"
	, t2."V2ENHANCEDPERSONS"
	, t2."V2ENHANCEDORGANIZATIONS"
	, t2."V2ALLNAMES"
	from A0_FILTERED as t1 
	join gdelt.knowledge as t2 on 
	t1.sourceurl = t2."V2DOCUMENTIDENTIFIER";


	DROP TABLE IF EXISTS gdelt.joined;
	CREATE TABLE gdelt.joined AS
	select * from B00_filter_knowledge;

	drop table if exists gdelt.categories;
	create table gdelt.categories AS 
	select distinct split_part(unnest(string_to_array("V2ENHANCEDTHEMES",';')),',',1) as theme_categories
    from gdelt.joined;
end;
$$ language plpgsql;

call gdelt.filter_events();
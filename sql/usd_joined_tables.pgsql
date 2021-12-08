create or replace procedure usd.join_tables() as $$

begin 
	
	create temp table A00_selection as 
	select 
	t1."EVENTID" 
	, t2."CITY_ID" 
	, t3."REPORTID" 
	, t2."CITY" 
	, t1."COUNTRY" 
	, t1."EYEAR" 
	, t1."EMONTH" 
	, t1."EDAY" 
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
	t1."REPORTID1" = t3."REPORTID";

	create temp table B00_filter as
	select * from A00_selection
	where lower("COUNTRY") like '%vietnam%';

	
	drop table if exists usd.joined;
	create table usd.joined (like B00_filter);

	insert into usd.joined 
	select * from B00_filter;
	
end;
$$ language PLPGSQL;
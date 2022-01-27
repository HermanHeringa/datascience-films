/*
found a dataset

*/


DROP TABLE IF EXISTS imdb.filtered;
CREATE TABLE imdb.filtered as 
select 
    tconst as id 
    , "primaryTitle"
    , "startYear"
    , genres 
    , event_depicted 
    , vote_count 
    , vote_average 
    , plot 
    , case when 'hitler' = any(string_to_array(lower(t2."events depicted"),' ')) 
    or 'second world war' = any(string_to_array(lower(t2."events depicted"),' ') )
    or '2nd world war' = any(string_to_array(lower(t2."events depicted"),' '))
    or 'nazi' = any(string_to_array(lower(t2."events depicted"),' '))
    or 'nazi germany' = any(string_to_array(lower(t2."events depicted"),' '))
    then 'second world war'
    when 'vietnam' = any(string_to_array(lower(t2."events depicted"),' ')) 
    or 'vietnam war' = any(string_to_array(lower(t2."events depicted"),' ')) 
    or 'guerilla' = any(string_to_array(lower(t2."events depicted"),' ')) 
    or 'vietcong' = any(string_to_array(lower(t2."events depicted"),' ')) 
    then 'Vietnam War'
	end as historical_event
	from kaggle.raw 



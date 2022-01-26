drop table if exists kaggle.filtered;
create table kaggle.filtered as
select 
    title
    , date_part('year', release_date::date) as movie_release_year
    , genres 
    , overview as plot 
    , vote_count 
    , vote_average 
    , case when 'hitler' = any(string_to_array(lower(keywords),',')) 
    or 'second world war' = any(string_to_array(lower(keywords),',')) 
    or '2nd world war' = any(string_to_array(lower(keywords),',')) 
    or 'nazi' = any(string_to_array(lower(keywords),',')) 
    or '1945' = any(string_to_array(lower(keywords),',')) 
    then 'second world war'
    when 'vietnam' = any(string_to_array(lower(keywords),',')) 
    or 'vietnam war' = any(string_to_array(lower(keywords),',')) 
    or 'guerilla' = any(string_to_array(lower(keywords),',')) then 'Vietnam War'
	end as historical_event
	from kaggle.raw 



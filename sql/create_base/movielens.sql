create table movielens.links (
id varchar
,imdb_id varchar
, tmd_id varchar
)
2

create table movielens.movies (
id varchar
,title varchar
, genre varchar
)


\copy movielens.movies from /home/shivan/school/jaar_4/data_science/resources/movies.csv delimiter ',' csv header;
DROP TABLE IF EXISTS movielens.filtered;
CREATE TABLE movielens.filtered AS 
SELECT 
    t1."movieId" 
    ,t1.title
    ,concat_ws(',', t1.genre1
    ,t1.genre2
    ,t1.genre3
    ,t1.genre4
    , t1.genre5
    ,t1.genre6
    ,t1.genre7
    , t1.genre8
    , t1.genre9
    , t1.genre10
    , t1.genre11) as genres
    , t1.year
    , t1.gem_rat as avg_rat
    , t1.amount
    , t2."events depicted" 
FROM movielens.movies as t1
LEFT JOIN movielens.vietnam_movies as t2 on 
    t1."movieId" = t2."movieId" 
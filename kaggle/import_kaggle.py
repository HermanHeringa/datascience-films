from os import sep
import pandas as pd 
import psycopg2 
from sqlalchemy import create_engine
import json
from ast import literal_eval


engine = create_engine('postgresql+psycopg2://postgres:@localhost:5432/film', )
df = pd.read_csv('resources/tmdb_5000_movies.csv',sep=',')


for row_no, row in enumerate(df.genres):
    row_genres = []
    for index, genre in enumerate(json.loads(row)):
        row_genres.append(genre['name'])
    df.loc[df.index == row_no, 'genres'] =  ",".join(row_genres)
print(df.head(5))
df.to_sql(name='raw', con=engine, if_exists='replace',index=False, schema='kaggle') 


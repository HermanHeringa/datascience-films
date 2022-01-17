from os import sep
import pandas as pd 
import psycopg2 
from sqlalchemy import create_engine

engine = create_engine('postgresql+psycopg2://postgres:@localhost:5432/film', )
df = pd.read_csv('resources/postwar_ww2_films.csv',sep=';')
print(df)
df.to_sql(name='movies', con=engine, if_exists='replace',index=False, schema='wikipedia') 
import pandas as pd 
import psycopg2 
from sqlalchemy import create_engine

engine = create_engine('postgresql+psycopg2://postgres:@localhost:5432/film', )
df = pd.read_csv('resources/Vietnam_titels_movielens.csv')
print(df)
df.to_sql(name='vietnam_movies', con=engine, if_exists='replace',index=False, schema='movielens') 
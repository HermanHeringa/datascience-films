import pandas as pd 
import openpyxl
from pathlib import Path
import click 
import os
from sqlalchemy import create_engine




# source 
#https://www.prio.org/data/6
DIR = Path('../resources/USD/')
ENGINE = create_engine('postgresql+psycopg2://postgres:@localhost:5432/film', )


@click.command()
@click.pass_context
def import_all(ctx):
    '''
    Imports EVERYTHING and joins data to usd.joined table
    '''
    ctx.invoke(import_reports)
    ctx.invoke(import_cities)
    ctx.invoke(import_city_years)
    ctx.invoke(import_events)


@click.command()
def import_events():
    '''
    Imports events into the usd.events table 
    '''
    df = pd.read_excel(DIR/'events.xlsx')
    df.to_sql(name='events', con=ENGINE, if_exists='replace',index=False, schema='usd') 



@click.command()
def import_cities():
    '''
    Imports cities into the usd.cities table 
    '''
    df = pd.read_excel(DIR/'cities.xlsx')
    df.to_sql(name='cities', con=ENGINE, if_exists='replace',index=False, schema='usd') 



@click.command()
def import_city_years():
    '''
    Imports cityyears into the usd.city_years table 
    '''
    df = pd.read_excel(DIR/'cityyear.xlsx')
    df.to_sql(name='city_year', con=ENGINE, if_exists='replace',index=False, schema='usd') 


@click.command()
def import_reports():
    '''
    Imports reports into the usd.reports table 
    '''
    df = pd.read_excel(DIR/'reports.xlsx')
    df.to_sql(name='reports', con=ENGINE, if_exists='replace',index=False, schema='usd') 


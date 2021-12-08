import pandas as pd 
import psycopg2
from sqlalchemy import create_engine
import http
from time import sleep

from datetime import date, datetime,timedelta
import gdelt
import logging

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO, format="%(asctime)s %(name)s %(message)s")

class gdelt_importer:

    def __init__(self) -> None:
        self.year = datetime.today().strftime('%Y')
        self.month = datetime.today().strftime('%m')
        self.day = datetime.today().strftime('%d')
        self.gd1 = gdelt.gdelt(version=1)
        self.gd2 = gdelt.gdelt(version=2)
        self.engine = create_engine('postgresql+psycopg2://postgres:@localhost:5432/film', )


    #last command:  python -m cli download-gdelt-v1 "1982-01-02" "1983-01-01"
    def import_bulk_v1(self, min_date: str, max_date: str):
        date_time_start = datetime.strptime(min_date, '%Y-%m-%d')
        date_time_end = datetime.strptime(max_date, '%Y-%m-%d')
        try:
            df = self.gd1.Search(date=[min_date, max_date], table='events')
            df.to_sql(name='events_v1', con=self.engine, if_exists='append',index=False, schema='gdelt') 
            sleep(1)
        except ValueError as e:
            print(e)
        print("Done!")


        df_gkgs = pd.DataFrame()
        for single_date in self._daterange(date_time_start, date_time_end):
            try:
                print(single_date.strftime("%Y-%m-%d"))
                df_loop_gkgs = self.gd1.Search([single_date.strftime("%Y-%m-%d")], table='gkg')
                df_gkgs = df_gkgs.append(df_loop_gkgs)
            except ValueError as e:
                continue
        df_gkgs.to_sql(name='knowlegde_v1', con=self.engine, if_exists='replace',index=False, schema='gdelt') 

    def import_bulk_v2(self, min_date: str, max_date: str):
        """
        downloads and parses everything in the local postgres db within two dates
        dates specified in "YYY-MM-DD" format as string

        example : import_bulk("2021-09-10", "2021-10-10")
        """

        # import events and insert
        logger.info(f"importing event between {min_date} and {max_date}")
        df = self.gd2.Search([min_date, max_date], table='events',coverage=True,translation=False)
        df.to_sql(name='events', con=self.engine, if_exists='replace',index=False, schema='gdelt') 

        logger.info(f"importing mentions between {min_date} and {max_date}")
        #import knowledge and insert, need to be in a for loop to construct dates, since the gkg and mention table only operates on one date.

        date_time_start = datetime.strptime(min_date, '%Y-%m-%d')
        date_time_end = datetime.strptime(max_date, '%Y-%m-%d')

        df_mentions = pd.DataFrame()
        df_gkgs = pd.DataFrame()

        for single_date in self._daterange(date_time_start, date_time_end):
            try:
                print(single_date.strftime("%Y-%m-%d"))
                df_loop_mentions = self.gd2.Search([single_date.strftime("%Y-%m-%d")], table='mentions')
                df_loop_gkgs = self.gd2.Search([single_date.strftime("%Y-%m-%d")], table='gkg')
                df_mentions = df_mentions.append(df_loop_mentions)
                df_gkgs = df_gkgs.append(df_loop_gkgs)
            except ValueError as e:
                continue
        print("inserting mentions")
        df_mentions.to_sql(name='mention', con=self.engine, if_exists='replace',index=False, schema='gdelt') 
        #import mentions and insert 
        print("inserting gkgs")
        df_gkgs.to_sql(name='knowlegde', con=self.engine, if_exists='replace',index=False, schema='gdelt') 

    def _daterange(self, start_date, end_date):
        for n in range(int((end_date - start_date).days)):
            yield start_date + timedelta(n)

import click
from gdelt_importer import gdelt_importer
import logging

logger = logging.getLogger(__name__)
cli_group = click.Group()


@cli_group.command()
@click.argument('min_date', type=str)
@click.argument('max_date', type=str)
def download_gdelt_v2(min_date, max_date):
    logging.info("download gdelt stuff")
    logging.info(f"parameter min_date: {min_date}")
    logging.info(f"parameter max_date: {max_date}")
    gdelt_importer().import_bulk_v2(min_date=min_date, max_date=max_date)

@cli_group.command()
@click.argument('min_date', type=str)
@click.argument('max_date', type=str)
def download_gdelt_v1(min_date, max_date):
    gdelt_importer().import_bulk_v1(min_date=min_date, max_date=max_date)


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(name)s %(message)s")
    cli_group()

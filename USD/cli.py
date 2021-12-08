import click
import import_usd
import logging

logger = logging.getLogger(__name__)
cli_group = click.Group()

cli_group.add_command(import_usd.import_all)
cli_group.add_command(import_usd.import_cities)
cli_group.add_command(import_usd.import_city_years)
cli_group.add_command(import_usd.import_events)
cli_group.add_command(import_usd.import_reports)


if __name__ == "__main__":
    cli_group()

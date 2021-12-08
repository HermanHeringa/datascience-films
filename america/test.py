from chroniclingamerica import ChronAm
from pprint import pprint

fetcher = ChronAm('hitler')
for item in fetcher.fetch():
    pprint(item)  # Or do something more interesting
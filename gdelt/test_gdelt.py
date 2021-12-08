import gdelt
import pandas as pd

gd = gdelt.gdelt(version=2)

results = gd.Search(['2016-10-19','2016-10-22'], table='events', coverage=True, translation=False)
print(results)
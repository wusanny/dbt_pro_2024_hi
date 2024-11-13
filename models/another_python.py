import pandas as pd
import numpy as np

def model(dbt, session):
 df1 = dbt.ref("asset_hours")
 df = df1.to_pandas()

 group = df.groupby('asset_id').apply(lambda group: group.interpolate(method='index'))
 return df

import pandas as pd
import numpy as np

def model (dbt, session):
    df = pd.DataFrame(
        {'date': [1, 2, 3, 1, 2,3,4,5],
        'asset_id': [3, 3, 3, 10, 10,10,10,10],
        'hours': [1, np.nan, 3, 2, 4, np.nan, np.nan,7]
    })
    group = df.groupby('asset_id').apply(lambda group: group.interpolate(method='index'))
    return group
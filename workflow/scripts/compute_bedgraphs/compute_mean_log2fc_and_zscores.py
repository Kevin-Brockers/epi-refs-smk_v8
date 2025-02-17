# Import packages
import logging
import os
import numpy as np
import pandas as pd

# # Predefine logging
# logging.basicConfig(
#     format='{asctime} - {levelname} - {message}',
#     style='{',
#     datefmt='%Y-%m%d %H:%M',
#     level=logging.DEBUG,
#     filename=snakemake.log[0],
#     filemode='a'
# )

# File paths
## Input
bedgraph_paths = snakemake.input['bedgraphs']

## Params
drop_na = snakemake.params['drop_na']
low_pct_filter = snakemake.params['low_pct_filter']
high_pct_filter = snakemake.params['high_pct_filter']
## Output
mean_bedgraph_path = snakemake.output['mean_bedgraph']
zscore_bedgraph_path = snakemake.output['zscore_bedgraph']
percentile_filtered_zscore_bedgraph_path = \
    snakemake.output['percentile_filtered_zscore_bedgraph_path']

# Script

# Load data
bedgraphs = []

for path in bedgraph_paths:
    _df = pd.read_csv(path,
                      sep='\t',
                      header=None,
                      index_col=[0, 1, 2])

    bedgraphs.append(_df)

bedgraphs = pd.concat(bedgraphs, axis=1)

if drop_na:
    bedgraphs = bedgraphs[bedgraphs.notna().all(axis=1)]

# Compute mean
mean_bedgraph = bedgraphs.mean(axis=1)

# Compute zscore
mean = mean_bedgraph.mean(axis=0)
std = mean_bedgraph.std(axis=0)
zscore_bedgraph = (mean_bedgraph - mean) / std

# Remove strongest outlier regions in the data

percentiles = zscore_bedgraph.quantile((low_pct_filter, high_pct_filter))

percentile_filtered_zscore = zscore_bedgraph[
    (zscore_bedgraph > percentiles[low_pct_filter]) \
    & (zscore_bedgraph < percentiles[high_pct_filter])]
# Write to file
mean_bedgraph.to_csv(mean_bedgraph_path, 
                     sep='\t', 
                     index=True,
                     header=None)

zscore_bedgraph.to_csv(zscore_bedgraph_path, 
                       sep='\t',
                        index=True, 
                        header=None)

percentile_filtered_zscore.to_csv(percentile_filtered_zscore_bedgraph_path, 
                     sep='\t', 
                     index=True,
                     header=None)
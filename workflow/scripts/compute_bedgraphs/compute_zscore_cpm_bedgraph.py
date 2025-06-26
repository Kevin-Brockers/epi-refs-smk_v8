# Import packages
import os
import numpy as np
import pandas as pd

# File paths
## Input
bedgraph_path = snakemake.input['bedgraph']

## Output
zscore_bedgraph_path = snakemake.output['bedgraph_zscore']

# Load data
bedgraph = pd.read_csv(
    bedgraph_path,
    sep='\t',
    names=[
        'chr', 
        'start', 
        'end', 
        'cpm'])

# Compute the mean
mean = bedgraph['cpm'].mean()
std = bedgraph['cpm'].std()

# Compute the zscore
bedgraph['zscore'] = (bedgraph['cpm'] - mean) / std

# Write to file
bedgraph[['chr', 'start', 'end', 'zscore']].to_csv(
    zscore_bedgraph_path,
    sep='\t',
    header=None,
    index=False)
# Import packages
import logging
import os
import numpy as np
import pandas as pd

# Predefine logging
logging.basicConfig(
    format='{asctime} - {levelname} - {message}',
    style='{',
    datefmt='%Y-%m%d %H:%M',
    level=logging.DEBUG,
    filename=snakemake.log[0],
    filemode='a')

# File pahts
## Input
counts_path = snakemake.input['counts']

## Params
drop_non_covered_bins = snakemake.params['drop_non_covered_bins']

## Output
cpm_bedgraph = snakemake.output['bg']

# Script

## Load data
logging.info('Load data')
df = pd.read_cvs(counts_path,
                 sep='\t',
                 skiprows=2,
                 usecols=[1, 2, 3, 6],
                 names=['chr', 
                        'start', 
                        'end',
                        'counts'])

if drop_non_covered_bins:
    logging.info('Drop uncovered sites')
    df = df[df > 0]

# Scale data
logging.info('Scale data')
df = df * (1e6 / df.sum())

# Write to file
df = df.reset_index()
df.to_csv(cpm_bedgraph,
          sep='\t',
          header=None,
          index=False)
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
    filemode='a'
)

# File paths
## Inputs
treatment_counts_path = snakemake.input['treatment']
control_counts_path = snakemake.input['control']

## Params
drop_na = snakemake.params['drop_na']

## Outputs
log2fc_bedgraph = snakemake.output['bg']

# Define functions for processing
def load_bedgraphs(path='', col_label=''):
    df = pd.read_csv(path,
        sep='\t',
        skiprows=2,
        usecols=[1, 2, 3, 6],
        names=['chr', 'start', 'end', col_label],
        index_col=['chr', 'start', 'end'],
    )
    return df


def scale_log2fc_data(processing_dict='', 
                      drop_na=drop_na,
                      out_path=''
                      ):
    _concat_df = []

    logging.info('Load counts as bedgraphs:')
    # Load data
    for key, path in processing_dict.items():
        logging.info(f'Load {path} as {key}')

        df = load_bedgraphs(path=path,
                            col_label=key)
        _concat_df.append(df)

    logging.info('Concat data')
    _concat_df = pd.concat(_concat_df, 
                           axis=1)
    
    logging.info('CPM scale bedgraphs')
    _concat_df_cpm = _concat_df * (1e6 / _concat_df.sum())

    logging.info('Drop windows with zero coverage')
    _concat_df_cpm = _concat_df_cpm[(_concat_df_cpm > 0).all(axis=1)]
    
    if drop_na:
        logging.info('Filter rows containing NAs')
        _concat_df_cpm = _concat_df_cpm[_concat_df_cpm.notna().all(axis=1)]

    # Log2 transform
    _concat_df_cpm = np.log2(_concat_df_cpm)
    # Compute log2fc
    _log2fc_data = _concat_df_cpm['treatment'] - _concat_df_cpm['control']
    
    _log2fc_data = _log2fc_data.reset_index()

    logging.info('Write bedgraph to file')
    _log2fc_data.to_csv(out_path, 
                        sep='\t',
                        header=None,
                        index=False)


# Process data
processing_dict = dict(treatment=treatment_counts_path,
                       control=control_counts_path)

scale_log2fc_data(processing_dict=processing_dict,
                  out_path=log2fc_bedgraph)
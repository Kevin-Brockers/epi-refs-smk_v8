def params_get_genome():
    ans = ''
    _path = CUSTOM_GENOME_PATH
    # Check whether path is remote or not
    if _path.startswith(("http://", "https://", "ftp://", "sftp://")):
        if _path.endswith('gz'):
            # Is remote and compressed
            command = f'wget --quiet {_path} -O {output[0]}'
        else:
            # Is remote and not compressed
            command = f'wget -qO- {_path} | gzip -c > {output[0]}'
    else:
        if _path.endswith('gz'):
            # Is local and compressed
            command = f'cp {_path} {output[0]}'
        else:
            # Is local and not compressed
            command = f'gzip -c {_path} > {output[0]}'

    # Construct command
    return command


def params_trim_galore(wildcards):
    sample_id = wildcards['sample_id']

    _sequencer = SAMPLES_COMPLETE.query("sample_id == @sample_id")\
        ['Sequencer'].iloc[0]

    return config['TRIM_GALORE_PARAMS'][_sequencer]


def params_featurecounts_reads_in_bins(wildcards):
    sample_id = wildcards['sample_id']

    # Get the sequencing mode
    _seq_type = SAMPLES_COMPLETE.query("sample_id == @sample_id")\
        ['Sequencing_type'].iloc[0]
    
    if _seq_type == 'single':
        return config['FEATURECOUNTS_EXTRA_SE']
    elif _seq_type == 'paired':
        return config['FEATURECOUNTS_EXTRA_PE']
    else:
        raise ValueError('Sequencing type not know')
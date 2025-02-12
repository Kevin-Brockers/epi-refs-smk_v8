def input_sra_fastq_dump(wildcards):
    ans = {}

    sample_id = wildcards['sample_id']

    ans['sra_file'] = expand(
        rules.sra_prefetch.output.sra_file,
        sra_id = SAMPLES_COMPLETE.query("sample_id == @sample_id")['SRA_ID'])

    return ans


def params_trim_galore(wildcards):
    sample_id = wildcards['sample_id']
    _sequencer = SAMPLES_COMPLETE.query("sample_id == @sample_id")['Sequencer'].iloc[0]

    return config['TRIM_GALORE_PARAMS'][_sequencer]
def input_trim_galore_se(wildcards):
    ans = []
    
    sample_id = wildcards['sample_id']
    
    ans.extend(
        expand(rules.sra_fastq_dump_se.output.fq,
            sra_id = SAMPLES_COMPLETE.query("sample_id == @sample_id")\
                ['SRA_ID'].iloc[0]))
    return ans


def input_trim_galore_pe(wildcards):
    ans = []

    sample_id = wildcards['sample_id']
    
    ans.extend(
        expand(rules.sra_fastq_dump_pe.output.fq1,
            sra_id = SAMPLES_COMPLETE.query("sample_id == @sample_id")\
                ['SRA_ID'].iloc[0]))

    ans.extend(
        expand(rules.sra_fastq_dump_pe.output.fq2,
            sra_id = SAMPLES_COMPLETE.query("sample_id == @sample_id")\
                ['SRA_ID'].iloc[0]))
    return ans


def params_trim_galore(wildcards):
    sample_id = wildcards['sample_id']

    _sequencer = SAMPLES_COMPLETE.query("sample_id == @sample_id")\
        ['Sequencer'].iloc[0]

    return config['TRIM_GALORE_PARAMS'][_sequencer]


def input_queryname_sortbam(wildcards):
    ans = []

    sample_id = wildcards['sample_id']

    # Get the sequencing mode
    _seq_type = SAMPLES_COMPLETE.query("sample_id == @sample_id")\
        ['Sequencing_type'].iloc[0]
    
    if _seq_type == 'single':
        ans = rules.bowtie2_alignment_se.output
    elif _seq_type == 'paired':
        ans = rules.bowtie2_alignment_pe.output
    else:
        raise ValueError('Sequencing type not know')

    return ans


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
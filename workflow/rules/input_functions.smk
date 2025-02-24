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


def input_compute_log2fc_bedgraphs_cpm(wildcards):
    ans = {}
    sample_id = wildcards['sample_id']
    window_size = wildcards['window_size']

    # Get control sample ID
    control_sra = SAMPLES_COMPLETE.query('sample_id == @sample_id')\
        ['Control'].iloc[0]

    control_sample_id = SAMPLES_COMPLETE.query('SRA_ID == @control_sra')\
        ['sample_id'].iloc[0]

    ans['treatment'] = expand(
        rules.featurecounts_reads_in_bins.output.indiv_counts,
            sample_id=sample_id,
            window_size=window_size)[0]

    ans['control'] = expand(
        rules.featurecounts_reads_in_bins.output.indiv_counts,
            sample_id=control_sample_id,
            window_size=window_size)[0]

    return ans


def input_compute_mean_log2fc_and_zscores(wildcards):
    ans = []
    sample_id_mean = wildcards['sample_id_mean']
    window_size = wildcards['window_size']

    sample_ids = SAMPLES_COMPLETE.query("sample_id_mean == @sample_id_mean")\
        ['sample_id']

    ans.extend(expand(rules.compute_log2fc_bedgraphs_cpm.output.bg,
        sample_id=sample_ids,
        window_size=window_size))

    return ans


def input_bam_compare_deeptools(wildcards):
    ans = {}
    sample_id = wildcards['sample_id']
    window_size = wildcards['window_size']

    # Get control sample ID
    control_sra = SAMPLES_COMPLETE.query('sample_id == @sample_id')\
        ['Control'].iloc[0]

    control_sample_id = SAMPLES_COMPLETE.query('SRA_ID == @control_sra')\
        ['sample_id'].iloc[0]

    ans['treatment_bam'] = expand(
        rules.sortbam.output,        
            sample_id=sample_id,
            window_size=window_size)[0]
    ans['treatment_bai'] = expand(
        rules.indexbam.output,
        sample_id=sample_id,
        window_size=window_size)[0]
    

    ans['control_bam'] = expand(
        rules.sortbam.output,
            sample_id=control_sample_id,
            window_size=window_size)[0]

    ans['control_bai'] = expand(
        rules.indexbam.output,
            sample_id=control_sample_id,
            window_size=window_size)[0]

    ans['blacklist'] = expand(
        rules.merge_blacklist.output,
        genome=config['REFERENCE_GENOME'])

    return ans
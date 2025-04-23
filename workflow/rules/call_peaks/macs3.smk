def input_call_peaks_macs3(wildcards):
    ans = {}

    sample_id_mean = wildcards['sample_id_mean']

    # Get the corresponding control sample
    geo_id = SAMPLES_COMPLETE.query(
        "sample_id_mean == @sample_id_mean")\
            ['GEO_ID'].iloc[0]

    control_id = SAMPLES_COMPLETE.query(
        "GEO_ID == @geo_id and Target == 'Input'")\
            ['sample_id_mean'].iloc[0]

    ans['treatment_bam'] = expand(rules.merge_bam_files.output,
        sample_id_mean=sample_id_mean)
    ans['treatment_bai'] = expand(rules.index_merged_bam_files.output,
        sample_id_mean=sample_id_mean)
    ans['control_bam'] = expand(rules.merge_bam_files.output,
        sample_id_mean=control_id)
    ans['control_bai'] = expand(rules.index_merged_bam_files.output,
        sample_id_mean=control_id)
    return ans


rule macs3_call_peaks_narrow:
    input:
        unpack(input_call_peaks_macs3)
    output:
        dir = directory(str(RESULTS_DIR / 'macs3_call_peaks' / 'narrow' /
            '{sample_id_mean}'))
    log:
        str(LOG_DIR / 'macs3' / 'call_peaks' / 'narrow' / 
            '{sample_id_mean}.log')
    params:
        genome_size = config['EFF_GENOME_SIZES'][config['REFERENCE_GENOME']],
        extra = config['MACS3_NARROW_EXTRA']
    threads:
        1
    conda:
        "../../envs/macs3.yml"
    resources:
        mem_mb = 16000,
        tmpdir = config['TEMP_DIR']
    shell:
        """
            echo $TMPDIR
            macs3 callpeak \
                -t {input.treatment_bam} \
                -c {input.control_bam} \
                -g {params.genome_size} \
                {params.extra} \
                -n {wildcards.sample_id_mean}_narrow \
                --outdir {output.dir} \
                &> {log}
        """

rule macs3_call_peaks_broad:
    input:
        unpack(input_call_peaks_macs3)
    output:
        dir = directory(str(RESULTS_DIR / 'macs3_call_peaks' / 'broad' /
            '{sample_id_mean}'))
    log:
        str(LOG_DIR / 'macs3' / 'call_peaks' / 'broad' / 
            '{sample_id_mean}.log')
    params:
        genome_size = config['EFF_GENOME_SIZES'][config['REFERENCE_GENOME']],
        extra = config['MACS3_BROAD_EXTRA']
    threads:
        1
    conda:
        "../../envs/macs3.yml"
    resources:
        mem_mb = 16000,
        tmpdir = config['TEMP_DIR']
    shell:
        """
            echo $TMPDIR
            macs3 callpeak \
                --broad \
                -t {input.treatment_bam} \
                -c {input.control_bam} \
                -g {params.genome_size} \
                {params.extra} \
                -n {wildcards.sample_id_mean}_broad \
                --outdir {output.dir} \
                &> {log}
        """
rule merge_bam_files:
    input:
        input_merge_bam_files
    output:
        str(BAM_DIR / 'deduplicated_sorted_merged' / 
            '{sample_id_mean}.sorted.bam')
    params:
        
    threads:
        32
    conda:
        "../../envs/alignment.yml"
    resources:
        mem_mb = 32000
    shell:
        """
            samtools merge \
                -@ {threads} \
                -f {output} {input}
        """


rule index_merged_bam_files:
    input:
        rules.merge_bam_files.output
    output:
        str(BAM_DIR / 'deduplicated_sorted_merged' / 
            '{sample_id_mean}.sorted.bam.bai')
    threads:
        16
    resources:
        mem_mb = 32000
    conda:
        '../../envs/alignment.yml'
    shell:
        """
            samtools index \
            -@ {threads} \
            {input[0]} {output[0]}
        """


use rule featurecounts_reads_in_bins as \
    merged_bams_feature_counts_reads_in_bins with:
    input:
        bam = rules.merge_bam_files.output,
        bai = rules.index_merged_bam_files.output,
        saf = expand(rules.genomic_windows_to_saf.output.saf_tsv,
            genome=config['REFERENCE_GENOME'],
            window_size='{window_size}')
    output:
        indiv_counts = str(TEMP_DIR / 'featurecounts' / 
            'count_reads_in_bins' / 
            'merged_bam_indiv_counts_{window_size}_bps' /
            '{sample_id_mean}_counts.txt')
    log:
        str(LOG_DIR / 'featurecounts' / 'count_reads_in_bins' / 'merged_bams' /
            '{window_size}' / '{sample_id_mean}_{window_size}.log')
    params:
        extra = params_featurecounts_reads_in_bins_merged_bams,
        min_map_quality = config['FEATURECOUNTS_MIN_Q'],
        max_length = config['MAX_FRAGMENT_LENGTH']


rule convert_counts_to_bedgraphs:
    input:
        rules.merged_bams_feature_counts_reads_in_bins.output.indiv_counts
    output:
        bg_count = str(RESULTS_DIR / 'bedgraphs' / 'merged_bams' / 
            '{window_size}' / 'counts' / 
            '{sample_id_mean}_{window_size}_counts.bedgraph'),
        bg_cpm = str(RESULTS_DIR / 'bedgraphs' / 'merged_bams' / 
            '{window_size}' / 'cpm' / 
            '{sample_id_mean}_{window_size}_cpm.bedgraph')
    threads:
        1
    shell:
        """
        SF=$(awk -F '\t' 'NR>2{{sum += $7}}; END{{print sum}}' {input})

        awk -F '\t' -v OFS='\t' \
            'NR>2{{print $2, $3, $4, $7}}' \
            {input} \
            > {output.bg_count}

        awk -F '\t' -v OFS='\t' \
            'NR>2{{print $2, $3, $4, ($7/(1000000/'$SF'))}}' \
            {input} \
            > {output.bg_cpm}
        """


rule compute_log2fc_bedgraphs_cpm_merged_bams:
    input:
        unpack(input_compute_log2fc_bedgraphs_cpm_merged_bams)
    output:
        bg = str(RESULTS_DIR / 'bedgraphs' / 'merged_bams' / 
            '{window_size}' / 'log2fc_cpm' / 
            '{sample_id_mean}_{window_size}_log2fc_cpm.bedgraph')
    log:
        str(LOG_DIR / 'compute_bedgraphs' / 'merged_bams' / 'log2fc' / 
            '{sample_id_mean}_res_{window_size}.log')
    params:
        drop_na = True
    threads:
        1
    conda:
        "../../envs/analysis_stack.yml"
    resources:
        mem_mb = 16000
    script:
        "../../scripts/compute_bedgraphs/compute_log2fc_bedgraphs_merged_bams.py"
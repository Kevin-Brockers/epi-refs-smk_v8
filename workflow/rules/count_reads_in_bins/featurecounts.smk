rule featurecounts_reads_in_bins:
    input:
        bam = rules.sortbam.output,
        bai = rules.indexbam.output,
        saf = expand(rules.bl_rmv_genomic_windows_to_saf.output.saf_tsv,
            genome=config['REFERENCE_GENOME'],
            window_size='{window_size}')
    output:
        indiv_counts = str(TEMP_DIR / 'featurecounts' / 
            'count_reads_in_bins' / 'indiv_counts_{window_size}_bps' /
            '{sample_id}_counts.txt')
    log:
        str(LOG_DIR / 'featurecounts' / 'count_reads_in_bins' / 
            '{window_size}' / '{sample_id}_{window_size}.log')
    params:
        extra = config['FEATURECOUNTS_EXTRA'],
        min_map_quality = config['FEATURECOUNTS_MIN_Q'],
        max_length = config['MAX_FRAGMENT_LENGTH']
    threads:
        32
    conda:
        "../../envs/count_reads_in_bins.yml"
    resources:
        mem_mb = 16000
    shell:
        """
            featureCounts \
                -T {threads} \
                -Q {params.min_map_quality} \
                -D {params.max_length} \
                -F SAF \
                -a {input.saf} \
                {params.extra} \
                -o {output.indiv_counts} \
                {input.bam} \
                2> {log}
        """



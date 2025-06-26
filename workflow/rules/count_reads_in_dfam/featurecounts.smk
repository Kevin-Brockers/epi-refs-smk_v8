rule featurecounts_reads_in_bins_dfam_annotations:
    input:
        bam = rules.sortbam.output,
        bai = rules.indexbam.output,
        saf = config['DFAM_ANNOTATIONS_SAF']
    output:
        indiv_counts = str(TEMP_DIR / 'featurecounts' / 
            'count_reads_in_bins' /  'dfam_annotations' / 'indiv_counts_bps' /
            '{sample_id}_counts_dfam_annotations.txt')
    log:
        str(LOG_DIR / 'featurecounts' / 'count_reads_in_bins' / 
            '{sample_id}.log')
    params:
        extra = params_featurecounts_reads_in_bins,
        min_map_quality = config['FEATURECOUNTS_MIN_Q'],
        max_length = config['MAX_FRAGMENT_LENGTH']
    threads:
        32
    conda:
        "../../envs/count_reads_in_bins.yml"
    resources:
        mem_mb = 64000
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
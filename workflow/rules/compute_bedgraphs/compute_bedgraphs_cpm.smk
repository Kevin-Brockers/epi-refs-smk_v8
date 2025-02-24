rule compute_bedgraphs_cpm:
    input:
        counts = rules.featurecounts_reads_in_bins.output.indiv_counts
    output:
        bg = str(RESULTS_DIR / 'bedgraphs' / '{window_size}_bps' / 'cpm' / 
            'indiv_replicates' / '{sample_id}_res_{window_size}_bps_cpm.bedgraph')
    log:
        str(LOG_DIR / 'compute_bedgraphs' / 'cpm' / 
            '{sample_id}_res_{window_size}.log')
    params:
        drop_non_covered_bins = True
    threads:
        1
    conda:
        "../../envs/analysis_stack.yml"
    resources:
        mem_mb = 16000
    shell:
        "../../scripts/compute_bedgraphs/compute_cpm_bedgraphs.py"
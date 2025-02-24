rule compute_mean_log2fc_and_zscores:
    input:
        bedgraphs = input_compute_mean_log2fc_and_zscores
    output:
        mean_bedgraph = str(RESULTS_DIR / 'bedgraphs' / '{window_size}_bps' /
            'log2_fc' /  'mean_replicates' / 
            '{sample_id_mean}_res_{window_size}_bps_mean_log2fc.bedgraph'),
        zscore_bedgraph = str(RESULTS_DIR / 'bedgraphs' / '{window_size}_bps' /
            'mean_replicates_zscores' / 
            '{sample_id_mean}_res_{window_size}_bps_mean_log2fc_zscores.bedgraph'),
        percentile_filtered_zscore_bedgraph_path = \
            str(RESULTS_DIR / 'bedgraphs' / '{window_size}_bps' /
            'mean_replicates_zscores_percentile_filtered' / 
            '{sample_id_mean}_res_{window_size}_bps_mean_log2fc_zscores_percentile.bedgraph'),
    log:
        
    params:
        drop_na = True,
        high_pct_filter = 0.99,
        low_pct_filter = 0.01
    threads:
        1
    conda:
        "../../envs/analysis_stack.yml"
    resources:
        mem_mb = 8000
    script:
        "../../scripts/compute_bedgraphs/compute_mean_log2fc_and_zscores.py"
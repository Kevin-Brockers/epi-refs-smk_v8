rule compute_log2fc_bedgraphs_cpm:
    input:
        unpack(input_compute_log2fc_bedgraphs_cpm)
    output:
        bg = str(RESULTS_DIR / 'bedgraphs' / '{window_size}_bps' / 'log2_fc' / 
            'indiv_replicates' / '{sample_id}_res_{window_size}_bps.bedgraph')
    log:
        str(LOG_DIR / 'compute_bedgraphs' / 'log2fc' / 
            '{sample_id}_res_{window_size}.log')
    params:
        drop_na = True # Drops sites in the genome where either treat or control has missing values
    threads:
        1
    conda:
        "../../envs/analysis_stack.yml"
    resources:
        mem_mb = 32000
    script:
        "../../scripts/compute_bedgraphs/compute_log2fc_bedgraphs.py"
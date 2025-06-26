rule compute_zscore_cpm_bedgraph:
    input:
        bedgraph = rules.convert_counts_to_bedgraphs.output.bg_cpm
    output:
        bedgraph_zscore = str(RESULTS_DIR / 'bedgraphs' / 'merged_bams' / 
            '{window_size}' / 'zscores' / 
            '{sample_id_mean}_{window_size}_cpm_zscores.bedgraph')
    threads:
        1
    conda:
        "../../envs/analysis_stack.yml"
    resources:
        mem_mb = 16000
    script:
        "../../scripts/compute_bedgraphs/compute_zscore_cpm_bedgraph.py"



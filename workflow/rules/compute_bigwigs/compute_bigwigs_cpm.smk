use rule parse_bedgraph_to_bigwig as parse_cpm_bedgraph_to_bigwig with:
    input:
        bedgraph = rules.convert_counts_to_bedgraphs.output.bg_cpm,
        chromsizes = expand(rules.compute_chromsizes.output,
            genome=config['REFERENCE_GENOME'])
    output:
        bw = str(RESULTS_DIR / 'bigwigs' / 'merged_bams' / 
            '{window_size}_bps' / 'cpm' / 
            '{sample_id_mean}_{window_size}_cpm.bw')


use rule parse_bedgraph_to_bigwig as parse_cpm_zscore_bedgraph_to_bigwig with:
    input:
        bedgraph = rules.compute_zscore_cpm_bedgraph.output.bedgraph_zscore,
        chromsizes = expand(rules.compute_chromsizes.output,
            genome=config['REFERENCE_GENOME'])
    output:
        bw = str(RESULTS_DIR / 'bigwigs' / 'merged_bams' / 
            '{window_size}_bps' / 'cpm_zscore' / 
            '{sample_id_mean}_{window_size}_cpm_zscore.bw')
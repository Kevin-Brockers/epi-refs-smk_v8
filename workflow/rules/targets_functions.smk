def targets():
    TARGETS = []

    TARGETS.extend(
        expand(
            rules.compute_bedgraphs_cpm.output,
            sample_id = SAMPLES_COMPLETE['sample_id'],
            window_size=config['GBIN_SIZES']
        )
    )
    # Add log2 data, only for samples where a control sample exists
    TARGETS.extend(
        expand(
            rules.compute_mean_log2fc_and_zscores.output,
            sample_id_mean=SAMPLES_TREATMENT['sample_id_mean'],
            window_size=config['GBIN_SIZES']
        )
    )
    
    return set(TARGETS)
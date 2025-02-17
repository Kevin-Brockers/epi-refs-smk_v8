def targets():
    TARGETS = []
    TARGETS.extend(
        expand(
            rules.compute_mean_log2fc_and_zscores.output,
            sample_id_mean=SAMPLES_TREATMENT['sample_id_mean'],
            window_size=config['GBIN_SIZES']
        )
    )
    
    return set(TARGETS)
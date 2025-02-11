def targets():
    TARGETS = []
    TARGETS.extend(
        expand(
            rules.featurecounts_reads_in_bins.output,
            sample_id=SAMPLES_COMPLETE['sample_id'],
            window_size=config['GBIN_SIZES']            
        )
    )
    return TARGETS
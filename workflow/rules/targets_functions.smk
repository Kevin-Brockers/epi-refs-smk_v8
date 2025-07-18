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
    if config['AGGREGATE_REPLICATES'] == 'mean':
        TARGETS.extend(
            expand(
                rules.compute_mean_log2fc_and_zscores.output,
                sample_id_mean=SAMPLES_TREATMENT['sample_id_mean'],
                window_size=config['GBIN_SIZES']
            )
        )

    elif config['AGGREGATE_REPLICATES'] == 'sum':
        TARGETS.extend(
            expand(
                rules.compute_log2fc_bedgraphs_cpm_merged_bams.output,
                sample_id_mean=SAMPLES_TREATMENT['sample_id_mean'],
                window_size=config['GBIN_SIZES']
            )
        )

        # Compute bigwigs
        rules_bigwigs = [
            rules.parse_cpm_bedgraph_to_bigwig.output,
            rules.parse_cpm_zscore_bedgraph_to_bigwig.output]

        for rule in rules_bigwigs:
            TARGETS.extend(
                expand(rule,
                    sample_id_mean=SAMPLES_COMPLETE['sample_id_mean'],
                    window_size=config['GBIN_SIZES'])
            )
            
        # Add peak calling
        for sample_id_mean in SAMPLES_TREATMENT['sample_id_mean']:
            if SAMPLES_TREATMENT.query(
                "sample_id_mean == @sample_id_mean")\
                ['Peak_type'].iloc[0] == 'narrow':

                TARGETS.extend(
                    expand(
                        rules.macs3_call_peaks_narrow.output,
                        sample_id_mean=sample_id_mean
                    )
                )

            elif SAMPLES_TREATMENT.query(
                "sample_id_mean == @sample_id_mean")\
                ['Peak_type'].iloc[0] == 'broad':

                TARGETS.extend(
                    expand(
                        rules.macs3_call_peaks_broad.output,
                        sample_id_mean=sample_id_mean
                    )
                )
        
        # Add counts in dfam
        # TARGETS.extend(
        #     expand(rules.featurecounts_reads_in_bins_dfam_annotations.output,
        #         sample_id = SAMPLES_COMPLETE['sample_id'])
        # )

        TARGETS.extend(
            expand(rules.featurecounts_reads_in_bins_dfam_annotations_merged_replicates.output,
                sample_id_mean = SAMPLES_TREATMENT['sample_id_mean'])
        )

    return set(TARGETS)
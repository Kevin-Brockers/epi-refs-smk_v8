rule make_regions_genomic_windows:
    """
        Creates a bed file with genomic windows of size speified in the config.
    """
    input:
        chromsizes = rules.filter_autosomal_chromsizes.output
    output:
        bed = str(EXTERNAL_DATA_DIR / 'genomic_windows' / 
            '{genome}_{window_size}_bps_genomic_windows.unfiltered_autosomal.bed')
    threads:
        1
    conda:
        '../../envs/count_reads_in_bins.yml'
    shell:
        """
            bedtools makewindows \
            -g {input.chromsizes} \
            -w {wildcards.window_size} \
            > {output.bed}
        """
        

rule filter_non_blacklist_regions_genomic_windows:
    input:
        bed = rules.make_regions_genomic_windows.output.bed,
        own_blacklist = rules.merge_blacklist.output
    output:
        str(EXTERNAL_DATA_DIR / 'own' / 
        '{genome}_{window_size}_bps_genomic_windows.own_bl_filtered_autosomal.bed')
    threads:
        1
    conda:
        '../../envs/count_reads_in_bins.yml'
    shell:
        """
            bedtools intersect \
            -v \
            -a {input.bed} \
            -b {input.own_blacklist} \
            > {output}
        """


rule bl_rmv_genomic_windows_to_saf:
    input:
        rules.filter_non_blacklist_regions_genomic_windows.output
    output:
        saf_tsv = str(EXTERNAL_DATA_DIR / 'own' / 
        '{genome}_{window_size}_bps_genomic_windows.own_bl_filtered_autosomal.saf')
    threads:
        1
    shell:
        """
            awk -v OFS='\t' \
            'BEGIN {{"GeneID", "Chr", "Start", "End", "Strand"}} \
            {{$1-$2-$3, $1, $2, $3, '.'}}' \
            {input} > {output}
        """

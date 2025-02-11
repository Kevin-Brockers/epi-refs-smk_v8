rule get_blacklist:
    output:
        str(EXTERNAL_DATA_DIR / 'blacklist' / '{genome}' / 
            '{genome}-blacklist.v2.bed.gz')
    params:
        path = 'https://github.com/Boyle-Lab/Blacklist/raw/master/lists/{genome}-blacklist.v2.bed.gz'
    threads:
        1
    shell:
        'wget --quiet {params.path} -O {output}'


rule slop_blacklist:
    input:
        bed = rules.get_blacklist.output,
        chromsizes = rules.filter_autosomal_chromsizes.output
    output:
        str(EXTERNAL_DATA_DIR / 'blacklist' / '{genome}' / 
            '{genome}-blacklist_sloped.v2.bed')
    params:
     slop_length = config['SLOP_LENGTH_BLACKLIST']
    threads:
        1
    conda:
        "../../envs/count_reads_in_bins.yml"
    shell:
        """
            bedtools slop \
                -i {input.bed} \
                -g {input.chromsizes} \
                -b {params.slop_length} \
                > {output}
        """

rule merge_blacklist:
    input:
        rules.slop_blacklist.output
    output:
        str(EXTERNAL_DATA_DIR / 'blacklist' / '{genome}' / 
            '{genome}-blacklist_sloped_merged.v2.bed')
    threads:
        1
    conda:
        "../../envs/count_reads_in_bins.yml"
    shell:  
        """
            bedtools merge \
                -i {input} \
                -d 1 \
                > {output}
        """
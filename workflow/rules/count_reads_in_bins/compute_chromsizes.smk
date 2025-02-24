rule compute_chromsizes:
    input:
        rules.index_genome.output
    output:
        str(EXTERNAL_DATA_DIR / 'chromsizes' / '{genome}.chrom.sizes')
    threads:
        1
    shell:
        """
            cut -f1,2  {input} > {output}
        """


rule filter_autosomal_chromsizes:
    input:
        rules.compute_chromsizes.output
    output:
        str(EXTERNAL_DATA_DIR / 'chromsizes_autosomal' / 
            '{genome}.autosomal.chrom.sizes')
    shell:
        """
            grep -E -i -e '\\<chr[[:digit:]]{{1,2}}\\b' {input} | \
            sort -k1,1 > {output}   
        """
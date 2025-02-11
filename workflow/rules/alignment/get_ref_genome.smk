rule get_genome:
    output:
        str(INDEX_DIR / 'sequence' / '{genome, [a-z0-9]+}.fa.gz')
    threads:
        1
    resources:
        http=1
    shell:
        'wget --quiet http://hgdownload.cse.ucsc.edu/goldenpath/{wildcards.genome}/bigZips/{wildcards.genome}.fa.gz -O {output[0]}'


rule unzip_genome:
    input:
        rules.get_genome.output
    output:
        temp(str(INDEX_DIR / 'sequence' / '{genome, [a-z0-9]+}.fa'))
    shell:
        """
             gzip -dc {input} > {output}
        """


rule index_genome:
    input:
        rules.unzip_genome.output
    output:
        str(INDEX_DIR / 'sequence' / '{genome, [a-z0-9]+}.fa.fai')       
    threads:
        1        
    conda:
        '../../envs/alignment.yml'
    resources:
        mem_mb = 4000
    shell:
        """
            samtools faidx {input} > {output}
        """



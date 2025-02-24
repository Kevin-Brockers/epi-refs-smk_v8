if config['USE_CUSTOM_GENOMES']:
    rule get_genome:
        output:
            str(INDEX_DIR / 'sequence' / '{genome, [a-z0-9]+}.fa.gz')
        params:
            command = params_get_genome
        threads:
            1
        resources:
            http=1
        shell:
            """
                {params.command}
            """


elif not config['USE_CUSTOM_GENOMES']:
    rule get_genome:
        output:
            str(INDEX_DIR / 'sequence' / '{genome, [a-z0-9]+}.fa.gz')
        params:
            path = 'http://hgdownload.cse.ucsc.edu/goldenpath/{wildcards.genome}/bigZips/{wildcards.genome}.fa.gz'
        threads:
            1
        resources:
            http=1
        shell:
            """
                wget --quiet {params.path} -O {output[0]}
            """


else:
    raise ValueError('Cannot find a reference genome, make sure it exists')


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



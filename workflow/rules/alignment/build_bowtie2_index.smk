rule generate_index_bowtie2:
    input:
        rules.get_genome.output
    output:
        str(INDEX_DIR / 'bowtie2' / 'index_{genome}' / '{genome}.1.bt2'),
        str(INDEX_DIR / 'bowtie2' / 'index_{genome}' / '{genome}.2.bt2'),
        str(INDEX_DIR / 'bowtie2' / 'index_{genome}' / '{genome}.3.bt2'),
        str(INDEX_DIR / 'bowtie2' / 'index_{genome}' / '{genome}.4.bt2'),
        str(INDEX_DIR / 'bowtie2' / 'index_{genome}' / '{genome}.rev.1.bt2'),
        str(INDEX_DIR / 'bowtie2' / 'index_{genome}' / '{genome}.rev.2.bt2'),
        prefix=str(INDEX_DIR / 'bowtie2' / 'index_{genome}' / '{genome}')
    log:
        str(LOG_DIR / 'bowtie2' / 'build.index_{genome}.log')
    threads:
        32
    resources:
        mem_mb=16000
    conda:
        '../../envs/alignment.yml'
    shell:
        """
            bowtie2-build \
                --seed 0 \
                --threads {threads} \
                -f {input} {output.prefix} &> {log} \
            # Dummy file to be used by further rules
            touch {output.prefix}
        """
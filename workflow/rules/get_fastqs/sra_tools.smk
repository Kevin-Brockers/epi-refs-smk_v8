rule sra_prefetch:
    output:
        sra_file = str(TEMP_DIR / 'sra_files' / '{sra_id}.sra')
    log:
        str(LOG_DIR / 'sra-tools' / 'sra_prefetch' / '{sra_id}.log')
    threads:
        1
    conda:
        '../../envs/sra_tools.yml'
    resources:
        html=1,
        mem_mb = 16000       
    shell:
        """
            prefetch \
            --max-size 150G \
            --force all {wildcards.sra_id} \
            -o {output.sra_file}
        """ 


# Single end dumping
rule sra_fastq_dump_se:
    input:
        rules.sra_prefetch.output.sra_file
    output:
        fq = str(EXTERNAL_DATA_DIR / 'fastq' / '{sra_id}' / 
            '{sra_id}.fastq.gz')
    params:
        fq_dir = str(EXTERNAL_DATA_DIR / 'fastq' / '{sra_id}')
    threads:
        1
    conda:
        '../../envs/sra_tools.yml'
    resources:
        mem_mb = 32000
    shell:
        """
            fastq-dump \
            {input} \
            --outdir {params.fq_dir} \
            --skip-technical \
            --gzip
        """


# Paired end dumping
rule sra_fastq_dump_pe:
    input:
        rules.sra_prefetch.output.sra_file
    output:
        fq1 = str(EXTERNAL_DATA_DIR / 'fastq' / '{sra_id}' / 
            '{sra_id}_1.fastq.gz'),
        fq2 = str(EXTERNAL_DATA_DIR / 'fastq' / '{sra_id}' / 
            '{sra_id}_2.fastq.gz')
    params:
        fq_dir = str(EXTERNAL_DATA_DIR / 'fastq' / '{sra_id}')
    threads:
        1
    conda:
        '../../envs/sra_tools.yml'
    resources:
        mem_mb = 32000
    shell:
        """
            fastq-dump \
            {input} \
            --outdir {params.fq_dir} \
            --split-files \
            --skip-technical \
            --gzip
        """
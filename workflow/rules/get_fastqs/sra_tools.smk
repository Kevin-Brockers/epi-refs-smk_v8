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


rule sra_fastq_dump:
    input:
        unpack(input_sra_fastq_dump)
    output:
        fq1 = str(EXTERNAL_DATA_DIR / 'fastq' / '{sample_id}' / 
            '{sample_id}_1.fastq.gz'),
        fq2 = str(EXTERNAL_DATA_DIR / 'fastq' / '{sample_id}' / 
            '{sample_id}_2.fastq.gz')
    params:
        fq_dir = str(EXTERNAL_DATA_DIR / 'fastq' / '{sample_id}')
    threads:
        1
    conda:
        '../../envs/sra_tools.yml'
    resources:
        mem_mb = 32000
    shell:
        """
            fastq-dump \
            {input.sra_file} \
            --outdir {params.fq_dir} \
            --split-files \
            --skip-technical \
            --gzip 
        """
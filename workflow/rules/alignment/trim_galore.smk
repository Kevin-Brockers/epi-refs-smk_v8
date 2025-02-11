rule trim_galore_pe:
    input:
        [rules.sra_fastq_dump.output.fq1, rules.sra_fastq_dump.output.fq2]
    output:
        fq1 = temp(
            str(TEMP_DIR / 'fastq' / 'trimmed' / 
            '{sample_id}' / '{sample_id}_1_val_1.fq.gz')),
        fq2 = temp(
            str(TEMP_DIR / 'fastq' / 'trimmed' / 
            '{sample_id}' / '{sample_id}_2_val_2.fq.gz')),
        out_dir = temp(directory(
            str(TEMP_DIR / 'fastq' / 'trimmed' / '{sample_id}'))),
        fastqc_dir = directory(
            str(QUALITY_CONTROL_DIR / 'fastqc' / 'trimmed' / '{sample_id}'))
    log:
        str(LOG_DIR / 'trimgalore' / '{sample_id}.log')
    params:
        extra = params_trim_galore
    threads:
        1
    conda:
        "../../envs/trim_galore.yml"
    resources:
        mem_mb = 16000
    shell:
        """
        mkdir {output.fastqc_dir} && \
        trim_galore \
            {params.extra} \
            -j {threads} \
            --gzip \
            --paired \
            --fastqc_args '--outdir {output.fastqc_dir}' \
            -o {output.out_dir} \
            {input} 2> {log}
        """



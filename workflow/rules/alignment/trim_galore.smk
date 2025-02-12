rule trim_galore_se:
    input:
        input_trim_galore_se
    output:
        fq = temp(
            str(TEMP_DIR / 'fastq' / 'trimmed' / 
            '{sample_id}' / '{sample_id}_trimmed.fq.gz')),
        out_dir = temp(directory(
            str(TEMP_DIR / 'fastq' / 'trimmed' / '{sample_id}'))),
        fastqc_dir = directory(
            str(QUALITY_CONTROL_DIR / 'fastqc' / 'trimmed' / '{sample_id}'))
    log:
        str(LOG_DIR / 'trimgalore' / '{sample_id}.log')
    params:
        extra = params_trim_galore
    threads:
        16
    conda:
        "../../envs/trim_galore.yml"
    resources:
        mem_mb = 16000
    shell:
        """
        mkdir {output.fastqc_dir} && \
        trim_galore \
            {params.extra} \
            -j 4 \
            --gzip \
            --fastqc_args '--outdir {output.fastqc_dir}' \
            --basename {wildcards.sample_id} \
            -o {output.out_dir} \
            {input} 2> {log}
        """


rule trim_galore_pe:
    input:
        input_trim_galore_pe
    output:
        fq1 = temp(
            str(TEMP_DIR / 'fastq' / 'trimmed' / 
            '{sample_id}' / '{sample_id}_val_1.fq.gz')),
        fq2 = temp(
            str(TEMP_DIR / 'fastq' / 'trimmed' / 
            '{sample_id}' / '{sample_id}_val_2.fq.gz')),
        out_dir = temp(directory(
            str(TEMP_DIR / 'fastq' / 'trimmed' / '{sample_id}'))),
        fastqc_dir = directory(
            str(QUALITY_CONTROL_DIR / 'fastqc' / 'trimmed' / '{sample_id}'))
    log:
        str(LOG_DIR / 'trimgalore' / '{sample_id}.log')
    params:
        extra = params_trim_galore
    threads:
        16
    conda:
        "../../envs/trim_galore.yml"
    resources:
        mem_mb = 16000
    shell:
        """
        mkdir {output.fastqc_dir} && \
        trim_galore \
            {params.extra} \
            -j 4 \
            --gzip \
            --paired \
            --fastqc_args '--outdir {output.fastqc_dir}' \
            --basename {wildcards.sample_id} \
            -o {output.out_dir} \
            {input} 2> {log}
        """

# {threads} \ check the --cores 4 explanation https://github.com/FelixKrueger/TrimGalore/blob/master/Docs/Trim_Galore_User_Guide.md

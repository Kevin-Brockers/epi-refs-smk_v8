# Single end
rule bowtie2_alignment_se:
    input:
        trimmed_read = rules.trim_galore_se.output.fq,
        index = expand(
            rules.generate_index_bowtie2.output.prefix,
            genome=config['REFERENCE_GENOME'])
    output:
        temp(str(BAM_DIR / 'unsorted_with_duplicates' / 'single_end' /
            '{sample_id}.unsorted.with_duplicates.bam'))
    log:
        str(LOG_DIR / 'bowtie2' / '{sample_id}.log')
    threads:
        32
    params:
        extra=config['BOWTIE2_EXTRA']
    conda:
        '../../envs/alignment.yml'
    resources:
        mem_mb=32000,
        time="1-00:00:00"
    shell:
        """
            (bowtie2 \
                --threads {threads} \
                {params.extra} \
                -x {input.index} \
                -U {input.trimmed_read} | \
            samtools view -Sbh -o {output}) &> {log}
        """


# Paired end
rule bowtie2_alignment_pe:
    input:
        trimmed_read1 = rules.trim_galore_pe.output.fq1,
        trimmed_read2 = rules.trim_galore_pe.output.fq2,
        index = expand(
            rules.generate_index_bowtie2.output.prefix,
            genome=config['REFERENCE_GENOME'])
    output:
        temp(str(BAM_DIR / 'unsorted_with_duplicates' / 'paired_end' /
            '{sample_id}.unsorted.with_duplicates.bam'))
    log:
        str(LOG_DIR / 'bowtie2' / '{sample_id}.log')
    threads:
        32
    params:
        extra=config['BOWTIE2_EXTRA'],
        max_fragment_length=config['MAX_FRAGMENT_LENGTH']
    conda:
        '../../envs/alignment.yml'
    resources:
        mem_mb=32000,
        time="1-00:00:00"
    shell:
        """
            (bowtie2 \
                --threads {threads} \
                {params.extra} \
                -X {params.max_fragment_length} \
                -x {input.index} \
                -1 {input.trimmed_read1} \
                -2 {input.trimmed_read2} | \
            samtools view -Sbh -o {output}) &> {log}
        """
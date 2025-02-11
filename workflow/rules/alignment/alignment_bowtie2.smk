rule bowtie2_alignment:
    input:
        trimmed_read1 = rules.trim_galore_pe.output.fq1,
        trimmed_read2 = rules.trim_galore_pe.output.fq2,
        index = expand(
            rules.generate_index_bowtie2.output.prefix,
            genome=config['REFERENCE_GENOME'])
    output:
        temp(str(BAM_DIR / 'unsorted_with_duplicates' / 
            '{sample_id}.unsorted.with_duplicates.bam'))
    log:
        str(LOG_DIR / 'bowtie2' / '{sample_id}.log')
    threads:
        32
    params:
        extra=config['BOWTIE2_EXTRA'],
        max_fragment_length=config['MAX_FRAGMENT_LENGTH']
    conda:
        '../../envs/alignment/bowtie2.yaml'
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
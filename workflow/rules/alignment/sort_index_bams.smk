def input_sortbam(wildcards):
    sample_id = wildcards['sample_id']

    # Get the sequencing type
    seq_type = SAMPLES_COMPLETE.query(
        "sample_id == @sample_id")\
            ['Sequencing_type'].iloc[0]

    if seq_type == 'single' or \
        (seq_type == 'paired' and not config['PE_SEQ_USE_SINGLE_READ']):
        return rules.remove_duplicates_picard.output.bam
    
    else:
        return rules.extract_reads_from_pe_alignment.output.bam 



rule sortbam:
    """
    Sorts aligned bam file
    """
    input:
        input_sortbam
    output:
        str(BAM_DIR / 'deduplicated_sorted' / '{sample_id}.sorted.bam')
    params:
        extra = "-m 4G"
    threads:
        8
    conda:
        '../../envs/alignment.yml'
    resources:
        mem_mb = 40000
    shell:
        """
            samtools sort \
            {params.extra} \
            -@ {threads} \
            -o {output[0]}  \
            {input[0]}
        """


rule indexbam:
    """
    Indexes bam file
    """
    input:
        rules.sortbam.output
    output:
        str(BAM_DIR / 'deduplicated_sorted' / '{sample_id}.sorted.bam.bai')
    threads:
        16
    resources:
        mem_mb = 32000
    conda:
        '../../envs/alignment.yml'
    shell:
        """
            samtools index \
            -@ {threads} \
            {input[0]} {output[0]}
        """
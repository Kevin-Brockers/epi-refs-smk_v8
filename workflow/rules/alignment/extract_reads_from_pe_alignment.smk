rule extract_reads_from_pe_alignment:
    input: 
        rules.remove_duplicates_picard.output.bam
    output:
        bam = temp(str(BAM_DIR / 'deduplicated_unsorted_read_extracted' / 
            '{sample_id}.dedup.unsorted.bam'))        
    params:
        sam_flag = config['SAM_FLAG_EXTRACT_READS_DICT'][config['PE_SEQ_USE_SINGLE_READ']]
    threads:
        8
    conda:
        '../../envs/alignment.yml'
    resources:
        mem_mb = 16000
    shell:
        """
            samtools view \
            -bh \
            -f {params.sam_flag} \
            -@ {threads} \
            -o {output.bam} \
            {input}
        """
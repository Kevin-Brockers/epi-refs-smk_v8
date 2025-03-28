rule queryname_sortbam:
    input:
        input_queryname_sortbam
    output:
        temp(str(BAM_DIR / 'query_sorted' /  
            '{sample_id}.query_sorted.with_duplicates.bam'))
    log:
        str(LOG_DIR / 'picard' / 'sort_sam' / '{sample_id}.log')
    params:
        sort_order = "queryname",
        extra = "VALIDATION_STRINGENCY=SILENT",
        #tmpdir = config['tmp-dir'],
        xmx = lambda wc, resources: "-Xmx"+str(int((resources.mem_mb/1000)*0.9)) + "G"
    threads:
        1
    conda:
        '../../envs/alignment.yml'
    resources:
        mem_mb = 100000, 
        tmpdir='.tmp/'
    shell:
        """
            picard {params.xmx} SortSam \
            INPUT={input} \
            OUTPUT={output} \
            SORT_ORDER={params.sort_order} \
            {params.extra} \
            TMP_DIR="temp_data" \
            MAX_RECORDS_IN_RAM=2000000 &> {log}
        """


rule remove_duplicates_picard:
    input:
        rules.queryname_sortbam.output
    output:
        bam = temp(str(BAM_DIR / 'deduplicated_unsorted' / 
            '{sample_id}.dedup.unsorted.bam')),
        metrics = str(BAM_DIR /  'deduplicated_unsorted' /
            '{sample_id}.picard.dedup.metrics.txt')
    log:
        str(LOG_DIR / 'picard' / 'dedup' / '{sample_id}.log')
    params:
        extra = "REMOVE_SEQUENCING_DUPLICATES=true ASSUME_SORT_ORDER=queryname " 
                "SORTING_COLLECTION_SIZE_RATIO=0.15",
        xmx = lambda wc, resources: "-Xmx"+str(int((resources.mem_mb/1000)*0.9)) + "G"
    threads:
        1
    conda:
        '../../envs/alignment.yml'
    resources:
        mem_mb = 100000,
        time="12:00:00",
        tmpdir='.tmp/'
    shell:
        """
            picard {params.xmx} MarkDuplicates \
            {params.extra} \
            INPUT={input} \
            OUTPUT={output.bam} \
            METRICS_FILE={output.metrics} \
            TMP_DIR="temp_data" \
            MAX_RECORDS_IN_RAM=2000000 &> {log}
        """
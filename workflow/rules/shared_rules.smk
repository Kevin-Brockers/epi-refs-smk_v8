rule parse_bedgraph_to_bigwig:
    input:
        bedgraph = '',
        chromsizes = ''
    output:
        bw = ''
    threads:
        1
    conda:
        "../../envs/ucsc-bedgraphtobigwig.yml"
    resources:
        mem_mb = 16000
    shell:
        """
        bedGraphToBigWig \
            {input.bedgraph} \
            {input.chromsizes} \
            {output.bw}
        """
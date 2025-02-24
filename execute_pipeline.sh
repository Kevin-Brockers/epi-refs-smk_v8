#! /bin/bash

snakemake \
    -j 100 \
    --workflow-profile profiles/cpu_normal \
    --rerun-incomplete \
    --notemp

# Plot the rule graph
snakemake --rulegraph | dot -Tpdf > snakeflow.pdf
snakemake --rulegraph | dot -Gdpi=300 -Tjpg -o snakeflow.jpg
#! /bin/bash

snakemake \
    -j 50 \
    --workflow-profile profiles/cpu_normal \
    --rerun-incomplete \
    --keep-going \
    --notemp

# Plot the rule graph
snakemake --rulegraph | dot -Tpdf > snakeflow.pdf
snakemake --rulegraph | dot -Gdpi=300 -Tjpg -o snakeflow.jpg
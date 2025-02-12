#! /bin/bash

snakemake \
    -j 200 \
    --workflow-profile profiles/cpu_normal \
    --rerun-incomplete \
    --notemp
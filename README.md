# epi-refs-smk_v8

## Rational

- `Epi-refs-smk_v8` is a basic and for sure to simplified `snakemake` pipeline to quickly generate epigenomic references
for downstream project.
- Installation of the base snakemake v8 conda env: `conda env create -f base_smk_8v.yml`
- Add the epigenomic references here: `config/sample_manifest.tsv`

## Set up

1. Install the base snakemake env
2. Fill out the `config/sample_manifest.tsv`
  - Read the `config/sample_manifest_notes.md`
3. Set the corresponding reference genome in `config['REFERENCE_GENOME]`

## Workflow overview

![snakeflow](snakeflow.jpg)
```mermaid
  graph TD;
  sra_prefetch --> trim_galore
  trim_galore --> bowtie2
  bowtie2 --> picard_deduplication
  picard_deduplication --> count_in_windows
  count_in_windows --> create_count_matrix
  count_in_windows --> compute_bedgraphs/bigwigs
  create_count_matrix --> cluster_samples
  create_count_matrix --> optional_cell_state_comparisons
```
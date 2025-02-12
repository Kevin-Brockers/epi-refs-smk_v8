# Commun explanation

## SRA_ID

- Short_read_archive ID

## GEO_ID

- GEO collection ID

## Target

- E.g the ChIP-Seq or other experimental type, 
- Example: CTCF or Input

## Condition

- Should describe the condition, the Target was chipped or studied
- Example: Stem cells, HeLa cells, heat-shock or similar

## Experiment

- This can be used for grouping several experiments from a given study
- Eexample: Epigenomic profiling of HeLa cells

## Replicate

- Can be numbers or letters, individual samples against a given Target, Condition and GEO_ID will be averaged in this
  pipeline
- Example: 1,2 or A, B

## Control

- Specify the control SRA_ID, this will be used when log2FC and z-scores will be calculated

## Pairing

- Placeholder atm, might be implemented for more complex studies

## Sequencing type

- Describes whether the samples have been sequenced in `paired end` or `single end` mode
- Accepts: `paired` or `single` as inputs

## Sequencer

- The sequencing platform, import to consider that depending on the platform used read trimming will be done for 2 or 4
  color chemistry.
- Supported sequencing platforms are: HiSeq4000, HiSeq2000, NovaSeq, NextSeq

## Peak_type

- If applicable, define whether narrow or broad peaks should be called. This feature is currently experimental not
  implemented but will be in the future.
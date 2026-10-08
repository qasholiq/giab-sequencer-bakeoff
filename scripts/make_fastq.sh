#!/usr/bin/env bash
# Subsample each platform to ~30x on chr20:10-15Mb and convert to FASTQ.
# Fractions = 30 / measured mean depth (69.36, 57.25, 44.66). Seed = 42.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p data/fastq

# Illumina (paired): -F 0x900 drops secondary/supplementary alignments.
# samtools view -s keeps both mates together (it hashes the read name).
samtools view -b -F 0x900 -s 42.4325 data/slices/illumina.bam \
  | samtools collate -u -O - \
  | samtools fastq -n -1 data/fastq/illumina_R1.fq.gz -2 data/fastq/illumina_R2.fq.gz \
      -0 /dev/null -s data/fastq/illumina_single.fq.gz -

# PacBio HiFi (single reads)
samtools view -b -F 0x900 -s 42.5240 data/slices/pacbio.bam \
  | samtools fastq - | gzip > data/fastq/pacbio.fq.gz

# Nanopore (single reads)
samtools view -b -F 0x900 -s 42.6717 data/slices/ont.bam \
  | samtools fastq - | gzip > data/fastq/ont.fq.gz

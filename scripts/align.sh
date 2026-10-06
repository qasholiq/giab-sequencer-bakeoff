#!/usr/bin/env bash
# Align 30x FASTQs to chr20 with platform-appropriate aligners.
set -euo pipefail
cd ~/giab-sequencer-bakeoff
REF=data/reference/chr20.fa
T=8
mkdir -p data/aligned

# Index for bwa-mem2 (one-off, about 1-2 minutes)
[ -f $REF.bwt.2bit.64 ] || bwa-mem2 index $REF

# Illumina: bwa-mem2, paired-end
bwa-mem2 mem -t $T -R '@RG\tID:illumina\tSM:HG002\tPL:ILLUMINA' $REF \
  data/fastq/illumina_R1.fq.gz data/fastq/illumina_R2.fq.gz \
  | samtools sort -@ 4 -o data/aligned/illumina.bam -

# PacBio HiFi: minimap2 preset for accurate long reads
minimap2 -ax map-hifi -t $T -R '@RG\tID:pacbio\tSM:HG002\tPL:PACBIO' $REF \
  data/fastq/pacbio.fq.gz | samtools sort -@ 4 -o data/aligned/pacbio.bam -

# Nanopore: minimap2 preset for noisier long reads
minimap2 -ax map-ont -t $T -R '@RG\tID:ont\tSM:HG002\tPL:ONT' $REF \
  data/fastq/ont.fq.gz | samtools sort -@ 4 -o data/aligned/ont.bam -

for f in illumina pacbio ont; do samtools index data/aligned/$f.bam; done

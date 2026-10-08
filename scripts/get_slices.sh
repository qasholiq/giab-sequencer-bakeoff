#!/usr/bin/env bash
# Stream chr20:10-15 Mb from the three remote GIAB HG002 BAMs (no full download) and report depth.
# Re-run if a transfer times out. Output: data/slices/{illumina,pacbio,ont}.bam (+ .bai)
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/config.sh
mkdir -p data/slices
printf "chr20\t10000000\t15000000\n" > data/region.bed
for spec in "illumina $ILLUMINA_URL" "pacbio $PACBIO_URL" "ont $ONT_URL"; do
  set -- $spec
  [ -s data/slices/$1.bam.bai ] || { samtools view -b -o data/slices/$1.bam "$2" chr20:10000000-15000000; samtools index data/slices/$1.bam; }
  samtools coverage -r chr20:10000000-15000000 data/slices/$1.bam | tail -n 1 | awk -v p=$1 '{print p, "reads="$4, "meandepth="$7, "meanbaseq="$8, "meanmapq="$9}'
done | tee data/slices/slice_stats.txt
echo "retrieved $(date -I)" >> data/slices/PROVENANCE.txt

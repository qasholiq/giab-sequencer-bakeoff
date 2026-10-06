#!/usr/bin/env bash
# Score each call set against the GIAB truth with rtg vcfeval
set -euo pipefail
cd ~/giab-sequencer-bakeoff
SDF=data/reference/chr20.sdf
[ -d $SDF ] || rtg format -o $SDF data/reference/chr20.fa
for p in illumina pacbio ont; do
  rm -rf results/eval_$p
  rtg vcfeval -b data/truth/truth.vcf.gz -c results/calls_$p/merge_output.vcf.gz \
    -t $SDF -e data/truth/benchmark_chr20_10-15Mb.bed -o results/eval_$p --threads 4
  echo "== $p"; cat results/eval_$p/summary.txt
done

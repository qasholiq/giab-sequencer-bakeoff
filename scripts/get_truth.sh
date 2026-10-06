#!/usr/bin/env bash
# Fetch GIAB HG002 v4.2.1 (GRCh38) truth variants + benchmark regions, chr20:10-15Mb only.
set -euo pipefail
cd ~/giab-sequencer-bakeoff
mkdir -p data/truth
B=https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG002_NA24385_son/NISTv4.2.1/GRCh38
bcftools view -r chr20:10000000-15000000 -Oz -o data/truth/truth.vcf.gz \
  $B/HG002_GRCh38_1_22_v4.2.1_benchmark.vcf.gz
tabix -p vcf data/truth/truth.vcf.gz
wget -c -O data/truth/benchmark_full.bed $B/HG002_GRCh38_1_22_v4.2.1_benchmark_noinconsistent.bed
awk -v s=10000000 -v e=15000000 '$1=="chr20" && $3>s && $2<e {a=($2<s)?s:$2; b=($3>e)?e:$3; print $1"\t"a"\t"b}' \
  data/truth/benchmark_full.bed > data/truth/benchmark_chr20_10-15Mb.bed

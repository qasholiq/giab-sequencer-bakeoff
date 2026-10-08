#!/usr/bin/env bash
# Fetch GRCh38 chr20 (GIAB no_alt_analysis_set, accession GCA_000001405.15) into data/reference/.
# Uses the .fai/.gzi indexes hosted next to the FASTA, so only chr20 blocks are downloaded.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p data/reference
URL=https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/references/GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fasta.gz
if [ ! -s data/reference/chr20.fa ]; then
  samtools faidx "$URL" chr20 > data/reference/chr20.fa
fi
samtools faidx data/reference/chr20.fa
cat data/reference/chr20.fa.fai   # expect: chr20  64444167 ...
echo "retrieved $(date -I)" >> data/reference/PROVENANCE.txt

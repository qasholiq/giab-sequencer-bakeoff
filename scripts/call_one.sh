#!/usr/bin/env bash
# usage: call_one.sh NAME PLATFORM MODEL   (BAM must be data/aligned/NAME.bam)
set -euo pipefail
cd ~/giab-sequencer-bakeoff
ROOT=$PWD; NAME=$1; PLAT=$2; MODEL=$3
mkdir -p results/timing
/usr/bin/time -v -o results/timing/$NAME.txt run_clair3.sh \
  --bam_fn=$ROOT/data/aligned/$NAME.bam --ref_fn=$ROOT/data/reference/chr20.fa \
  --threads=4 --platform=$PLAT --model_path=$CONDA_PREFIX/bin/models/$MODEL \
  --output=$ROOT/results/calls_$NAME --bed_fn=$ROOT/data/region.bed \
  --ctg_name=chr20 --sample_name=HG002

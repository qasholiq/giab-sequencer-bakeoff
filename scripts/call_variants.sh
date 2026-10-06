#!/usr/bin/env bash
# Call variants with Clair3. Run inside: conda activate calling
set -euo pipefail
cd ~/giab-sequencer-bakeoff
ROOT=$PWD
REF=$ROOT/data/reference/chr20.fa
MODELS=$CONDA_PREFIX/bin/models
THREADS=4   # WSL has about 7 GB RAM, so keep this modest
mkdir -p results/timing
printf "chr20\t10000000\t15000000\n" > data/region.bed
[ -x /usr/bin/time ] || { echo "Install timer first: sudo apt install -y time"; exit 1; }

run () {   # args: name platform model
  /usr/bin/time -v -o results/timing/$1.txt \
  run_clair3.sh --bam_fn=$ROOT/data/aligned/$1.bam --ref_fn=$REF \
    --threads=$THREADS --platform=$2 --model_path=$MODELS/$3 \
    --output=$ROOT/results/calls_$1 --bed_fn=$ROOT/data/region.bed \
    --ctg_name=chr20 --sample_name=HG002
}
run illumina ilmn ilmn
run pacbio hifi hifi_sequel2
run ont ont ont

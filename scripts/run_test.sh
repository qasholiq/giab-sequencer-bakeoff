#!/usr/bin/env bash
# One-command check: variant calling + truth-set scoring on the 200 kb test slice.
# Usage (inside the 'calling' env):  bash scripts/run_test.sh
set -euo pipefail
cd "$(dirname "$0")/.."
ROOT=$PWD
REF=$ROOT/data/reference/chr20.fa
[ -f "$REF" ] || { echo "Missing $REF - fetch the reference first (see README step 3)"; exit 1; }
SDF=data/reference/chr20.sdf
[ -d "$SDF" ] || rtg format -o "$SDF" "$REF"
OUT=results/test; mkdir -p $OUT
for spec in "illumina ilmn ilmn" "pacbio hifi hifi_sequel2" "ont ont ont"; do
  set -- $spec
  rm -rf $OUT/calls_$1 $OUT/eval_$1
  run_clair3.sh --bam_fn=$ROOT/test_data/$1.bam --ref_fn=$REF --threads=4 \
    --platform=$2 --model_path=$CONDA_PREFIX/bin/models/$3 \
    --output=$ROOT/$OUT/calls_$1 --bed_fn=$ROOT/test_data/region.bed \
    --ctg_name=chr20 --sample_name=HG002 > $OUT/clair3_$1.log 2>&1
  rtg vcfeval -b test_data/truth.vcf.gz -c $OUT/calls_$1/merge_output.vcf.gz \
    -t $SDF -e test_data/benchmark.bed -o $OUT/eval_$1 --threads 4 > /dev/null
  echo "== $1"; cat $OUT/eval_$1/summary.txt
done

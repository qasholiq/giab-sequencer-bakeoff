#!/usr/bin/env bash
# Stratified benchmarking: score each platform inside GIAB genome contexts
set -euo pipefail
cd ~/giab-sequencer-bakeoff
BASE=https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/genome-stratifications/v3.6/GRCh38@all
SDF=data/reference/chr20.sdf
BENCH=data/truth/benchmark_chr20_10-15Mb.bed
mkdir -p data/strat results/strat

declare -A QCUT=( [illumina]=5 [pacbio]=7 [ont]=13 )
for p in illumina pacbio ont; do
  bcftools view -i "QUAL>=${QCUT[$p]}" -f PASS,. -Oz -o results/strat/$p.filt.vcf.gz results/calls_$p/merge_output.vcf.gz
  tabix -f -p vcf results/strat/$p.filt.vcf.gz
done

cat > data/strat/list.txt << 'LIST'
all_benchmark_regions NONE
homopolymer_4to6 LowComplexity/GRCh38_SimpleRepeat_homopolymer_4to6_slop5.bed.gz
homopolymer_7to11 LowComplexity/GRCh38_SimpleRepeat_homopolymer_7to11_slop5.bed.gz
homopolymer_ge12 LowComplexity/GRCh38_SimpleRepeat_homopolymer_ge12_slop5.bed.gz
tandem_repeats LowComplexity/GRCh38_AllTandemRepeats.bed.gz
not_in_repeats_or_homopolymers LowComplexity/GRCh38_notinAllTandemRepeatsandHomopolymers_slop5.bed.gz
satellites LowComplexity/GRCh38_satellites_slop5.bed.gz
low_mappability Mappability/GRCh38_lowmappabilityall.bed.gz
not_low_mappability Mappability/GRCh38_notinlowmappabilityall.bed.gz
gc_extreme_lt25_gt65 GCcontent/GRCh38_gclt25orgt65_slop50.bed.gz
gc_normal_30to55 GCcontent/GRCh38_gc30to55_slop50.bed.gz
not_in_segdups SegmentalDuplications/GRCh38_notinsegdups.bed.gz
LIST

printf "stratum\tplatform\tbases\ttruth_TP\tFP\tFN\tprecision\tsensitivity\tF\n" > results/strat/strat_summary.tsv
while read -r name path; do
  if [ "$path" = "NONE" ]; then
    cp $BENCH data/strat/$name.chr20.bed
  else
    f=data/strat/$name.bed.gz
    [ -s $f ] || curl -sL --retry 3 -o $f "$BASE/$path"
    zcat $f | awk '$1=="chr20"' | sort -k1,1 -k2,2n | bedtools merge -i - \
      | bedtools intersect -a - -b $BENCH > data/strat/$name.chr20.bed
  fi
  bases=$(awk '{s+=$3-$2} END{print s+0}' data/strat/$name.chr20.bed)
  if [ "$bases" -eq 0 ]; then echo "skip $name (empty in window)"; continue; fi
  for p in illumina pacbio ont; do
    out=results/strat/${name}__$p
    rm -rf $out
    rtg vcfeval -b data/truth/truth.vcf.gz -c results/strat/$p.filt.vcf.gz -t $SDF \
      -e data/strat/$name.chr20.bed -o $out --threads 4 > /dev/null 2>&1
    tail -n 1 $out/summary.txt | awk -v n=$name -v p=$p -v b=$bases \
      '{printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", n,p,b,$2,$4,$5,$6,$7,$8}' >> results/strat/strat_summary.tsv
  done
  echo "done $name"
done < data/strat/list.txt

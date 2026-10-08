#!/usr/bin/env bash
# QC of the 30x FASTQs BEFORE alignment (handbook criteria 4 and 5). Run in the 'bake' env:
#   conda install -n bake -c bioconda nanoplot seqkit   (once)
#   bash scripts/qc.sh
# Report-only: nothing is filtered here, so we can state which thresholds the data justify.
set -euo pipefail
cd "$(dirname "$0")/.."
O=results/qc; mkdir -p $O/fastp $O/fastqc $O/nanoplot
# Illumina: adapter content, Q20/Q30, duplication, insert size peak (no output reads written)
fastp -i data/fastq/illumina_R1.fq.gz -I data/fastq/illumina_R2.fq.gz -j $O/fastp/illumina.json -h $O/fastp/illumina.html -w 4 2> $O/fastp/illumina.log
fastqc -t 4 -o $O/fastqc data/fastq/illumina_R1.fq.gz data/fastq/illumina_R2.fq.gz
# Long reads: length distribution, N50, mean read quality
for p in pacbio ont; do NanoPlot --fastq data/fastq/$p.fq.gz -t 4 -o $O/nanoplot/$p --N50 --no_static 2>/dev/null || NanoPlot --fastq data/fastq/$p.fq.gz -t 4 -o $O/nanoplot/$p --N50; done
seqkit stats -a data/fastq/*.fq.gz | tee $O/seqkit_stats.txt
python3 - <<'P' | tee $O/qc_summary.txt
import json
j = json.load(open("results/qc/fastp/illumina.json"))
s, f = j["summary"], j["filtering_result"]
print("== Illumina (fastp) ==")
for k in ("before_filtering",):
    print({m: s[k][m] for m in ("total_reads","read1_mean_length","read2_mean_length","q20_rate","q30_rate","gc_content")})
print("duplication_rate", j["duplication"]["rate"])
print("adapter_trimmed_reads", j.get("adapter_cutting", {}).get("adapter_trimmed_reads"))
print("insert_size_peak", j["insert_size"]["peak"], "unknown_fraction", j["insert_size"]["unknown"])
print("passed_filter", f["passed_filter_reads"], "low_quality", f["low_quality_reads"], "too_many_N", f["too_many_N_reads"])
P
for p in pacbio ont; do echo "== $p (NanoStats)"; grep -E "Mean read length|Mean read quality|Median read quality|Read length N50|Number of reads|Total bases|>Q" $O/nanoplot/$p/NanoStats.txt; done | tee -a $O/qc_summary.txt

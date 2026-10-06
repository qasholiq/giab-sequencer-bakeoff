# Pre-registered predictions (Task 3)

Project 11: The Sequencer Bake-Off. HG002, GRCh38 chr20:10-15 Mb, ~30x per platform,
GIAB v4.2.1 truth, scored with rtg vcfeval, stratified by GIAB genome contexts.

> Honesty note: these predictions are derived from instrument physics and published
> knowledge of each technology, not from our measured numbers. They were written
> AFTER the first pipeline run had been committed (see git history), so they are
> not blind. In the report we state this and judge each prediction on whether it
> follows from the mechanism, not just whether it matches.

## Instrument characteristics behind each dataset

| | Illumina | PacBio HiFi | ONT (Ultralong, PromethION) |
|---|---|---|---|
| Data used | 2x250 bp paired, Novoalign BAM | CCS 15-20 kb, Sequel II | UCSC Ultralong, phased BAM |
| Read length | 250 bp | ~15-20 kb | tens to hundreds of kb |
| Dominant error | substitutions, low rate | rare, random (consensus of many passes) | indels, esp. in homopolymers |
| Raw per-base accuracy | ~99.9% | ~99.9% (Q20+) | ~95-98%, depends on chemistry |
| Caller used | Clair3 ilmn | Clair3 hifi_sequel2 | Clair3 ont |

## Predictions

| # | Context | Prediction | Reason |
|---|---|---|---|
| P1 | Overall SNP+indel F1 | PacBio >= Illumina > ONT | HiFi is accurate AND long; ONT indel noise lowers precision/recall |
| P2 | Non-repeat, non-homopolymer sequence ("easy") | Illumina and PacBio close (both > 0.99); ONT lower but still decent | Easy regions are where platforms tie |
| P3 | Homopolymers >= 7 bp | ONT collapses (F1 well below 0.7); Illumina degrades mildly; PacBio stays high | Nanopore signal cannot count run length reliably; polymerase slippage on Illumina |
| P4 | Longest homopolymers (>= 12 bp) | ONT near failure; Illumina worse than in short runs | Same, amplified |
| P5 | Tandem repeats | Illumina loses sensitivity (reads shorter than repeat); PacBio best; ONT precision ok but recall low | 250 bp reads cannot span long repeats; ONT indel errors in repeat units |
| P6 | Low-mappability regions | Illumina loses sensitivity (multi-mapping reads, MAPQ 0); long reads far better | Read length beats ambiguity |
| P7 | GC extremes (<25% or >65%) | Illumina drops (PCR/coverage bias); PacBio roughly unaffected | Amplification bias in short-read library prep |
| P8 | Error attribution | Part of the Illumina and ONT deficit comes from the aligner (bwa-mem2 / minimap2) and the caller, not only the instrument | Task 6: aligner swap will move some calls |
| P9 | Cost per correctly called variant | Illumina cheapest; PacBio most expensive per Gb; ONT in between, strongly dependent on how many true variants it recovers | Cost per Gb differs; correct variants differ |

## What would falsify us

- ONT beating Illumina in homopolymers >= 7 bp.
- Illumina matching PacBio in low-mappability and tandem-repeat strata.
- Swapping the aligner changing no calls at all (then P8 is wrong).

## To fill after analysis

For each Pn: confirmed / partly / rejected, with the number from `results/strat/strat_summary.tsv`.

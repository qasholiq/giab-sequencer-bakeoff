# Report outline (8-12 pages)

## 1. Problem and biological framing
Variant calling underlies the diagnosis of inherited disease, cancer genomics and population studies. Each sequencing platform makes characteristic errors: Illumina short reads struggle in repetitive or poorly mappable sequence, PacBio HiFi reads are accurate but cost more per Gb, and Oxford Nanopore reads are very long but prone to insertion and deletion errors in homopolymers. Accuracy figures published by vendors are measured mostly on easy regions and do not tell a lab which platform to trust for which purpose.

We benchmark the three platforms on one individual, the Genome in a Bottle sample HG002, for which a curated set of high-confidence variants is available as the known answer. Our questions are: (1) how accurately does each platform recover true variants, (2) in which genomic contexts does each one fail (homopolymers, tandem repeats, low-mappability regions, extreme GC, segmental duplications), and (3) how much of the observed difference is caused by the aligner instead of the instrument. A call counts as correct only if it matches the truth set inside the high-confidence regions, so all conclusions apply to those regions and not to the whole genome.

Predictions of where each platform should fail, based on instrument characteristics, are in the repository (commit "Add pre-registered platform predictions (Task 3)"). That commit was made after the first results existed, so it is not a true pre-registration, and we state this openly.

## 2. Data (all accessions and retrieval dates)
- Sample: HG002 (NA24385), Genome in a Bottle.
- Base URL: https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son
- Illumina: NIST_Illumina_2x250bps/novoalign_bams/HG002.GRCh38.2x250.bam
- PacBio HiFi: PacBio_CCS_15kb_20kb_chemistry2/GRCh38/HG002.SequelII.merged_15kb_20kb.pbmm2.GRCh38.haplotag.10x.bam
- ONT: UCSC_Ultralong_OxfordNanopore_Promethion/HG002_GRCh38_ONT-UL_UCSC_20200508.phased.bam
- Truth set and benchmark regions: TO FILL (release version and URL from scripts/get_truth.sh); benchmark region file benchmark_chr20_10-15Mb.bed
- Reference: GRCh38 chr20 (TO FILL: source URL)
- Stratification files: TO FILL (names and source from scripts/stratify.sh)
- Analysed region: chr20:10-15 Mb, 4,914,359 benchmarked bases, 7,055 truth variants
- Subsampling: 30x per platform from original depths 69.36x (Illumina), 57.25x (PacBio), 44.66x (ONT), seed 42 (scripts/make_fastq.sh)
- Retrieval date: TO FILL (from download logs)

## 3. Methods
## 4. Results
## 5. Limitations
- One sample, one 5 Mb region of one chromosome.
- QUAL thresholds were chosen using the truth set, so scores are optimistic.
- The ONT data are ultra-long reads from a 2020 dataset, not current ONT chemistry.
- Aligner swap tested one alternative per platform.
- Some strata (homopolymers of 12 bp or longer, segmental duplications) contain very few truth variants; strata overlap.
## 6. Conclusion
## 7. Contribution statement
TO WRITE at the end, from the final commit history (git log --format="%an %s").
## 8. AI appendix
TO WRITE: tools used and what for.

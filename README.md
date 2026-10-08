# Sequencer Bake-Off: Illumina vs PacBio HiFi vs Nanopore on GIAB HG002 (chr20:10-15 Mb)

Question: which platform makes the fewest small-variant errors, in which genomic contexts, and how much of the
difference comes from the aligner rather than the instrument? Full write-up: `report/`.

**Headline (F-measure vs GIAB v4.2.1 truth, 7,055 variants):** PacBio HiFi 0.9986, Illumina 0.9903, Nanopore (2019 chemistry) 0.9126.

## Reproduce (Linux/WSL, conda or mamba, ~8 GB RAM)
1. `git clone https://github.com/qasholiq/giab-sequencer-bakeoff.git && cd giab-sequencer-bakeoff`
2. `conda env create -n calling -f envs/calling.yml && conda activate calling`
3. `bash scripts/get_reference.sh`  (GRCh38 chr20 only, streamed from GIAB; a few minutes)
4. **Headline command, ~70 s, uses the 200 kb data in `test_data/`:** `bash scripts/run_test.sh`
   Expected F on the test slice: Illumina ~0.994, PacBio 1.000, Nanopore ~0.929.

## Full pipeline (about 1-2 hours; needs the `bake` env from `envs/bake.yml` for alignment tools)
5. `bash scripts/get_slices.sh && bash scripts/get_truth.sh && bash scripts/make_fastq.sh`  (stream 5 Mb from the remote BAMs, truth set, 30x subsample, seed 42)
6. `bash scripts/qc.sh && bash scripts/align.sh && bash scripts/align_winnowmap.sh`
7. `snakemake -c4`  (Clair3 calling -> vcfeval scoring -> stratification -> plot; `snakemake -n` shows the graph)
8. `python scripts/make_report_figures.py && python scripts/cost_per_variant.py`
Aligner-swap commands (Bowtie2) are recorded in `results/aligner_swap/` and the report, Section 4.4.

## Layout
`scripts/` code | `envs/` conda environments | `test_data/` 200 kb slice (BAMs, truth, BED) | `results/summary`, `results/strat`, `results/aligner_swap` result tables | `docs/` instruments, cost, predictions | `report/` report and figures | `Snakefile` workflow

## Data (all public, retrieved 2026-10-06)
GIAB HG002 (NA24385): Illumina 2x250 Novoalign BAM, PacBio Sequel II HiFi 15/20 kb pbmm2 BAM, ONT-UL UCSC PromethION BAM (URLs in `scripts/config.sh`);
truth set NIST v4.2.1 GRCh38 + `benchmark_noinconsistent.bed`; stratifications v3.6; reference GCA_000001405.15 GRCh38 no_alt_analysis_set (chr20).
Large data is never committed; `data/` is git-ignored. Provenance files are written to `data/*/PROVENANCE.txt`.

## Authors
Gulnaz (pipeline, analysis), Inkar (environment, Snakemake workflow, instrument/cost table, predictions). See report Section 8.

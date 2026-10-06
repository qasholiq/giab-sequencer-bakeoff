# Sequencer Bake-Off: Illumina vs PacBio HiFi vs Nanopore on GIAB HG002 (chr20:10-15 Mb)

Question: which platform makes the fewest variant-calling errors, and how much of the
difference comes from the aligner rather than the instrument?

## Reproduce (Linux/WSL, conda or mamba)
1. `git clone https://github.com/qasholiq/giab-sequencer-bakeoff.git && cd giab-sequencer-bakeoff`
2. `conda env create -n calling -f envs/calling.yml && conda activate calling`
3. Fetch the reference: download GIAB GRCh38 no_alt_analysis_set, extract chr20 to `data/reference/chr20.fa` (see `scripts/<FETCH_SCRIPT>`).
4. Quick check (about <N> minutes, uses the 200 kb data in `test_data/`): `bash scripts/run_test.sh`
5. Full pipeline: `scripts/config.sh` holds the remote BAM URLs, then `<slice/align scripts in order>`, `bash scripts/call_variants.sh`, `bash scripts/evaluate.sh`, `bash scripts/stratify.sh`, `python scripts/plot_strat.py`.
6. Workflow definition: `snakemake -n` (Snakefile) shows the call -> evaluate -> stratify -> plot dependency graph.

## Layout
`scripts/` code, `envs/` conda environment, `test_data/` 200 kb test slice, `results/summary`,
`results/strat`, `results/aligner_swap` result tables, `docs/` instrument table and report notes.

## Data (all public, retrieved 2026-10-06 or earlier; confirm dates)
GIAB HG002 (NA24385): Illumina 2x250 (Novoalign BAM), PacBio Sequel II HiFi 15/20 kb, ONT-UL UCSC PromethION;
truth set NIST v4.2.1 GRCh38; stratifications v3.6; reference GRCh38 no_alt_analysis_set.
Large data is not committed; `data/` is git-ignored.

# Instrument, chemistry and cost table (HG002, chr20:10-15 Mb)

| Platform | Dataset (GIAB HG002) | Library / chemistry | Read length | Depth (original -> used) | Aligner (main run) | Aligner (swap) | Cost per Gb |
|---|---|---|---|---|---|---|---|
| Illumina | NIST_Illumina_2x250bps, novoalign BAM, GRCh38 | paired-end 2x250 | 2 x 250 bp | 69.36x -> 30x | bwa-mem2 | Bowtie2 | ~3.14 USD (derived) |
| PacBio HiFi | PacBio_CCS_15kb_20kb_chemistry2, Sequel II, pbmm2 BAM | HiFi (circular consensus), 15-20 kb library | TO FILL from BAM header | 57.25x -> 30x | minimap2 (map-hifi) | Winnowmap | ~20-30 USD (derived) |
| ONT | UCSC_Ultralong_OxfordNanopore_Promethion, 2020-05-08 | ultra-long library, PromethION | ultra-long, TO FILL (N50) | 44.66x -> 30x | minimap2 (map-ont) | Winnowmap | ~37 USD (derived) |

## Sources
- Dataset names, Illumina read layout: directory and file names in scripts/config.sh.
- Depths, subsampling (seed 42): comment and commands in scripts/make_fastq.sh.
- Aligners and presets: scripts/align.sh; swap: results/aligner_swap/.
- Read length and chemistry details for PacBio and ONT: to be read from the source BAM headers (samtools view -H) and the GIAB README in each FTP directory. The BAMs are on Gulnaz's machine.

## Cost per Gb (only numbers with a citable source; otherwise "not found")
| Platform | Cost per Gb | Source (URL, access date) |
|---|---|---|
| Illumina | ~3.14 USD/Gb | price: TGen academic price list 2026-27, NovaSeq X Plus 25B lane 300 cycles, 3136.63 USD; yield ~1 Tb per lane: NIH NISC platforms page; accessed 2026-10-06 |
| PacBio HiFi | ~20-30 USD/Gb | price: TGen price list 2026-27, Revio SMRT cell 1809.43 USD; yield 60-90 Gb per cell: NIH NISC platforms page; accessed 2026-10-06 |
| ONT | ~37 USD/Gb | price: TGen price list 2024-25, PromethION R10.4.1 flow cell 1494.63 USD; yield ~40 Gb per flow cell (ultra-long libraries): NIH NISC platforms page; accessed 2026-10-06 |

Notes: cost per Gb = price / yield, our own calculation from two sources, not a published figure. Prices come from one core facility (TGen), yields from another (NIH NISC). Prices exclude library preparation. The ONT price is from the 2024-25 list and is for R10.4.1, while our ONT data are a 2020 dataset on older chemistry, so the ONT figure is only an approximation.

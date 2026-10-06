# Instrument, chemistry and cost table (HG002, chr20:10-15 Mb)

| Platform | Dataset (GIAB HG002) | Library / chemistry | Read length | Depth (original -> used) | Aligner (main run) | Aligner (swap) | Cost per Gb |
|---|---|---|---|---|---|---|---|
| Illumina | NIST_Illumina_2x250bps, novoalign BAM, GRCh38 | paired-end 2x250 | 2 x 250 bp | 69.36x -> 30x | bwa-mem2 | Bowtie2 | not found |
| PacBio HiFi | PacBio_CCS_15kb_20kb_chemistry2, Sequel II, pbmm2 BAM | HiFi (circular consensus), 15-20 kb library | TO FILL from BAM header | 57.25x -> 30x | minimap2 (map-hifi) | Winnowmap | not found |
| ONT | UCSC_Ultralong_OxfordNanopore_Promethion, 2020-05-08 | ultra-long library, PromethION | ultra-long, TO FILL (N50) | 44.66x -> 30x | minimap2 (map-ont) | Winnowmap | not found |

## Sources
- Dataset names, Illumina read layout: directory and file names in scripts/config.sh.
- Depths, subsampling (seed 42): comment and commands in scripts/make_fastq.sh.
- Aligners and presets: scripts/align.sh; swap: results/aligner_swap/.
- Read length and chemistry details for PacBio and ONT: to be read from the source BAM headers (samtools view -H) and the GIAB README in each FTP directory. The BAMs are on Gulnaz's machine.

## Cost per Gb (only numbers with a citable source; otherwise "not found")
| Platform | Cost per Gb | Source (URL, access date) |
|---|---|---|
| Illumina | not found | |
| PacBio HiFi | not found | |
| ONT | not found | |

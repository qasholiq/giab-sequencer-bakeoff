PLAT = {"illumina": ("ilmn", "ilmn"), "pacbio": ("hifi", "hifi_sequel2"), "ont": ("ont", "ont")}

rule all:
    input:
        "results/strat/strat_barplot.png",
        expand("results/eval_{s}/summary.txt", s=PLAT)

rule call:
    input: "data/aligned/{s}.bam"
    output: "results/calls_{s}/merge_output.vcf.gz"
    params: plat=lambda w: PLAT[w.s][0], model=lambda w: PLAT[w.s][1]
    shell: "bash scripts/call_one.sh {wildcards.s} {params.plat} {params.model}"

rule evaluate:
    input: expand("results/calls_{s}/merge_output.vcf.gz", s=PLAT)
    output: expand("results/eval_{s}/summary.txt", s=PLAT)
    shell: "bash scripts/evaluate.sh"

rule stratify:
    input: expand("results/calls_{s}/merge_output.vcf.gz", s=PLAT)
    output: "results/strat/strat_summary.tsv"
    shell: "bash scripts/stratify.sh"

rule plot:
    input: "results/strat/strat_summary.tsv"
    output: "results/strat/strat_barplot.png"
    shell: "python scripts/plot_strat.py"

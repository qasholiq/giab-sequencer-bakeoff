import pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
d = pd.read_csv("results/strat/strat_summary.tsv", sep="\t")
order = list(dict.fromkeys(d["stratum"]))
names = {"illumina":"Illumina","pacbio":"PacBio HiFi","ont":"Nanopore"}
fig, axes = plt.subplots(1, 2, figsize=(14, 6), sharey=True)
for ax, metric in zip(axes, ["sensitivity", "precision"]):
    w = 0.27
    for i, p in enumerate(["illumina", "pacbio", "ont"]):
        s = d[d.platform == p].set_index("stratum").loc[order]
        ax.bar([x + (i-1)*w for x in range(len(order))], s[metric], w, label=names[p])
    ax.set_xticks(range(len(order)))
    ax.set_xticklabels(order, rotation=60, ha="right")
    ax.set_title(metric.capitalize() + " by genomic context")
    ax.set_ylabel(metric.capitalize()); ax.set_ylim(0, 1.02)
axes[0].legend()
plt.tight_layout()
plt.savefig("results/strat/strat_barplot.png", dpi=200)

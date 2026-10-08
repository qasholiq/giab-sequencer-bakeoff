"""Make report figures + CI table from results/strat/*.tsv. Run from repo root: python scripts/make_report_figures.py"""
import math, os, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
os.makedirs("report/figures", exist_ok=True)
a = pd.read_csv("results/strat/strat_summary.tsv", sep="\t")
b = pd.read_csv("results/strat/strat_summary_swap.tsv", sep="\t")
d = pd.concat([a, b]); d["n_truth"] = d.truth_TP + d.FN

def wilson(k, n, z=1.96):
    if n == 0: return (0.0, 0.0)
    p = k/n; den = 1+z*z/n; c = (p+z*z/(2*n))/den
    h = z*math.sqrt(p*(1-p)/n + z*z/(4*n*n))/den
    return c-h, c+h
d["sens_exact"] = d.truth_TP / d.n_truth
d["sens_lo"], d["sens_hi"] = zip(*[wilson(k, n) for k, n in zip(d.truth_TP, d.n_truth)])
d.to_csv("results/strat/strat_with_ci.tsv", sep="\t", index=False)

labels = {"all_benchmark_regions":"All benchmark regions","not_in_repeats_or_homopolymers":"Not in repeats/homopolymers",
 "homopolymer_4to6":"Homopolymer 4-6 bp","homopolymer_7to11":"Homopolymer 7-11 bp","homopolymer_ge12":"Homopolymer >=12 bp",
 "tandem_repeats":"Tandem repeats","low_mappability":"Low mappability","not_low_mappability":"Not low mappability",
 "gc_extreme_lt25_gt65":"GC <25% or >65%","gc_normal_30to55":"GC 30-55%","not_in_segdups":"Not in segdups",
 "segdups":"Segmental duplications","hard_lowmap_or_segdup":"Low-map or segdup (union)"}
order = list(labels)
names = {"illumina":"Illumina","pacbio":"PacBio HiFi","ont":"Nanopore"}
cols = {"illumina":"#1f77b4","pacbio":"#2ca02c","ont":"#d62728"}

fig, ax = plt.subplots(figsize=(9, 6.2))
for i, p in enumerate(["illumina", "pacbio", "ont"]):
    s = d[d.platform == p].set_index("stratum").loc[order]
    y = [j + (i-1)*0.25 for j in range(len(order))]
    ax.errorbar(s.sens_exact, y, xerr=[(s.sens_exact-s.sens_lo).clip(lower=0), (s.sens_hi-s.sens_exact).clip(lower=0)], fmt="o", ms=4, capsize=2, color=cols[p], label=names[p])
ax.set_yticks(range(len(order))); ax.set_yticklabels([f"{labels[o]} (n={int(d[(d.stratum==o)&(d.platform=='pacbio')].n_truth.iloc[0])})" for o in order], fontsize=8)
ax.invert_yaxis(); ax.set_xlabel("Sensitivity (fraction of truth variants recovered), 95% Wilson interval"); ax.set_xlim(0, 1.02)
ax.grid(axis="x", alpha=.3); ax.legend(loc="lower left", fontsize=8)
plt.tight_layout(); plt.savefig("report/figures/fig1_sensitivity_by_context.png", dpi=200); plt.close()

piv = d[d.platform.isin(names)].pivot(index="stratum", columns="platform", values="F").loc[order][["illumina","pacbio","ont"]]
fig, ax = plt.subplots(figsize=(7, 5.2))
im = ax.imshow(piv.values, cmap="RdYlGn", vmin=0, vmax=1, aspect="auto")
ax.set_xticks(range(3)); ax.set_xticklabels([names[c] for c in piv.columns]); ax.set_yticks(range(len(order))); ax.set_yticklabels([labels[o] for o in order], fontsize=8)
for i in range(piv.shape[0]):
    for j in range(3): ax.text(j, i, f"{piv.values[i,j]:.3f}", ha="center", va="center", fontsize=8)
plt.colorbar(im, label="F-measure"); plt.tight_layout(); plt.savefig("report/figures/fig2_F_heatmap.png", dpi=200); plt.close()

pairs = [("illumina","illumina_bt2","Illumina: Bowtie2 - BWA-MEM2"),("pacbio","pacbio_wm","HiFi: Winnowmap - minimap2"),("ont","ont_wm","Nanopore: Winnowmap - minimap2")]
fig, ax = plt.subplots(figsize=(9, 5.5))
for i, (m, s_, lab) in enumerate(pairs):
    x = d[d.platform == m].set_index("stratum").loc[order].F; y = d[d.platform == s_].set_index("stratum").loc[order].F
    ax.barh([j + (i-1)*0.27 for j in range(len(order))], (y-x).values, 0.27, label=lab)
ax.axvline(0, color="k", lw=.8); ax.set_yticks(range(len(order))); ax.set_yticklabels([labels[o] for o in order], fontsize=8); ax.invert_yaxis()
ax.set_xlabel("Change in F-measure when the aligner is swapped"); ax.legend(fontsize=8, loc="lower left"); ax.grid(axis="x", alpha=.3)
plt.tight_layout(); plt.savefig("report/figures/fig3_aligner_swap_delta_F.png", dpi=200); plt.close()

cost = {"Illumina":(0.0685,0.0685),"PacBio HiFi":(0.423,0.635),"Nanopore":(0.975,0.975)}
fig, ax = plt.subplots(figsize=(6.5, 3.4))
for i,(k,(lo,hi)) in enumerate(cost.items()):
    ax.barh(i, hi, color=list(cols.values())[i], alpha=.85)
    ax.text(hi+.02, i, f"${lo:.2f}" + (f"-{hi:.2f}" if lo!=hi else ""), va="center", fontsize=8)
ax.set_yticks(range(3)); ax.set_yticklabels(cost.keys()); ax.invert_yaxis(); ax.set_xlim(0,1.25)
ax.set_xlabel("Consumables cost per 1,000 correctly called variants (USD)")
plt.tight_layout(); plt.savefig("report/figures/fig4_cost_per_1000_correct.png", dpi=200)
print(piv.round(3))

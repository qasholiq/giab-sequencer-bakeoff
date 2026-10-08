"""Cost per correctly called variant = (bases sequenced for the 5 Mb window x cost per Gb) / true positives.
Inputs are logged in the repo: read counts/lengths (results/read_stats.txt, make_fastq.sh output), TP (results/summary/*.txt),
cost per Gb (docs/instruments.md; DERIVED, not published). Run: python scripts/cost_per_variant.py"""
bases = {"illumina": 305447*2*249, "pacbio": 10434*14217.9, "ont": 8223*19236.9}   # bp in the 30x subsample
tp    = {"illumina": 6969, "pacbio": 7044, "ont": 6066}                             # TP at best-F threshold
cost  = {"illumina": (3.14, 3.14), "pacbio": (20.10, 30.16), "ont": (37.37, 37.37)} # USD/Gb
print("platform  Gb_used  cost_USD(lo-hi)  USD_per_1000_correct(lo-hi)")
for p in bases:
    gb = bases[p]/1e9
    print(f"{p:9s} {gb:.4f}  {gb*cost[p][0]:.2f}-{gb*cost[p][1]:.2f}  {gb*cost[p][0]/tp[p]*1000:.3f}-{gb*cost[p][1]/tp[p]*1000:.3f}")

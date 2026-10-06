set -e
cd data/reference; meryl count k=15 output merylDB chr20.fa; meryl print greater-than distinct=0.9998 merylDB > repetitive_k15.txt; cd ../..
for p in ont pacbio; do preset=map-ont; [ $p = pacbio ] && preset=map-pb; winnowmap -W data/reference/repetitive_k15.txt -ax $preset -t 4 -R "@RG\tID:${p}_wm\tSM:HG002" data/reference/chr20.fa data/fastq/$p.fq.gz | samtools sort -@ 4 -o data/aligned/${p}_wm.bam -; samtools index data/aligned/${p}_wm.bam; done

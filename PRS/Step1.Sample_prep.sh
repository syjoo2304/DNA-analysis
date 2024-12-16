#!/bin/bash

##Prepare base data (GWAS Statistics)
## Generate input file with no duplicates based on the third column
cat base/ARHL_gWAS_summary_final.tsv | awk '{seen[$3]++; if(seen[$3]==1){ print}}'| gzip -> ARHL.nodup.gz

gunzip -c ARHL.nodup.gz |\
awk '!( ($4=="A" && $5=="T") || \
        ($4=="T" && $5=="A") || \
        ($4=="G" && $5=="C") || \
        ($4=="C" && $5=="G")) {print}' |\
    gzip > ARHL.QC.gz

##Prepare target data (case-control)
plink2 --vcf target/clean2.vcf --geno 0.01 --out ARHL_v23 --make-bed --double-id

python src/fam_edit.py
mv ARHL_v23.fam backup/
mv ARHL_e_23.fam ARHL_v23.fam

python src/bim_edit.py
mv ARHL_v23.bim backup/
mv ARHL_e_23.bim ARHL_v23.bim

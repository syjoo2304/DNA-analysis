#!/bin/bash

plink2 \
    --bfile POST \
    --extract POST.QC.prune.in \
    --keep POST.QC.valid \
    --rel-cutoff 0.125 \
    --out POST.QC #0 people excluded by --rel-cutoff.

plink2 \
    --bfile POST \
    --make-bed \
    --keep POST.QC.rel.id \
    --out POST.QC \
    --extract POST.QC.snplist \
    --exclude POST.mismatch \
    --a1-allele POST.a1


##Already BETA,  ODDS not included in GWAS summary stats (ARHL.QC2.gz)
gunzip ARHL.QC2.gz
mv ARHL.QC2 ARHL.QC.Transformed

plink2 \
    --bfile POST.QC \
    --clump-p1 1 \
    --clump-r2 0.1 \
    --clump-kb 250 \
    --clump ARHL.QC.Transformed \
    --clump-snp-field SNP \
    --clump-field P \
    --out POST
awk 'NR!=1{print $3}' POST.clumped >  POST.valid.snp

awk '{print $3,$9}' ARHL.QC.Transformed > SNP.pvalue

echo "0.001 0 0.001" > range_list 
echo "0.05 0 0.05" >> range_list
echo "0.1 0 0.1" >> range_list
echo "0.2 0 0.2" >> range_list
echo "0.3 0 0.3" >> range_list
echo "0.4 0 0.4" >> range_list
echo "0.5 0 0.5" >> range_list

#7th coloum is effect size of BETA
plink2 \
    --bfile POST.QC \
    --score ARHL.QC.Transformed 3 4 7 \
    --q-score-range range_list SNP.pvalue \
    --extract POST.valid.snp \
    --out POST

# First, we need to perform prunning
plink2 \
    --bfile POST.QC \
    --indep-pairwise 200 50 0.25 \
    --out POST
# Then we calculate the first 6 PCs
plink2 \
    --bfile POST.QC \
    --extract POST.prune.in \
    --pca 6 \
    --out POST

awk '{print $1,$2,$6}' POST.QC.fam > POST.phenotype
awk '{print $1,$2,$5}' POST.QC.fam > POST.cov

#vi POST.phenotype
#vi POST.cov  후에 header 추가
#header : FID, IID, Sex (ARHL.cov)
#FID, IID, PT (ARHL.phenotype)

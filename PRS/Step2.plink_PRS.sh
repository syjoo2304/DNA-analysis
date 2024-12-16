plink2 \
    --bfile POST \
    --hwe 1e-6 \
    --geno 0.01 \
    --write-snplist \
    --make-just-fam \
    --out POST.QC 

plink2 \
    --bfile POST \
    --keep POST.QC.fam \
    --extract POST.QC.snplist \
    --indep-pairwise 200 50 0.25 \
    --out POST.QC  

plink2 \
    --bfile POST \
    --extract POST.QC.prune.in \
    --keep POST.QC.fam \
    --het \
    --out POST.QC

##snp_number_reproducing_for_"ARHL.QC.gz"
gunzip ARHL.QC.gz 
python edit_arhlqc.py
gzip ARHL.QC2


library(data.table)
# Read in file
dat <- fread("POST.QC.het")
# Get samples with F coefficient within 3 SD of the population mean
valid <- dat[F<=mean(F)+3*sd(F) & F>=mean(F)-3*sd(F)] 
# print FID and IID for valid samples
fwrite(valid[,c("FID","IID")], "POST.valid.sample", sep="\t") 
q() # exit R

bim <- read.table("POST.bim") #693499
colnames(bim) <- c("CHR", "SNP", "CM", "BP", "B.A1", "B.A2")
# Read in QCed SNPs
qc <- read.table("POST.QC.snplist", header = F, stringsAsFactors = F) #688621
# Read in the GWAS data
arhl <-
    read.table(gzfile("ARHL.QC2.gz"),
            header = T,
            stringsAsFactors = F, 
            sep="\t")
# Change all alleles to upper case for easy comparison
arhl$A1 <- toupper(arhl$A1)
arhl$A2 <- toupper(arhl$A2)
bim$B.A1 <- toupper(bim$B.A1)
bim$B.A2 <- toupper(bim$B.A2)

# Merge summary statistic with target
info <- merge(bim, arhl, by = c("SNP", "CHR", "BP"))
# Filter QCed SNPs
info <- info[info$SNP %in% qc$V1,] #25692
# Function for finding the complementary allele
complement <- function(x) {
    switch (
        x,
        "A" = "T",
        "C" = "G",
        "T" = "A",
        "G" = "C",
        return(NA)
    )
}
# Get SNPs that have the same alleles across base and target
info.match <- subset(info, A1 == B.A1 & A2 == B.A2) #25692
# Identify SNPs that are complementary between base and target
info$C.A1 <- sapply(info$B.A1, complement)
info$C.A2 <- sapply(info$B.A2, complement)
info.complement <- subset(info, A1 == C.A1 & A2 == C.A2) #0
# Update the complementary alleles in the bim file
# This allow us to match the allele in subsequent analysis
complement.snps <- bim$SNP %in% info.complement$SNP
bim[complement.snps,]$B.A1 <-
    sapply(bim[complement.snps,]$B.A1, complement)
bim[complement.snps,]$B.A2 <-
    sapply(bim[complement.snps,]$B.A2, complement)

# identify SNPs that need recoding
info.recode <- subset(info, A1 == B.A2 & A2 == B.A1) #0
# Update the recode SNPs
recode.snps <- bim$SNP %in% info.recode$SNP
tmp <- bim[recode.snps,]$B.A1
bim[recode.snps,]$B.A1 <- bim[recode.snps,]$B.A2
bim[recode.snps,]$B.A2 <- tmp

# identify SNPs that need recoding & complement
info.crecode <- subset(info, A1 == C.A2 & A2 == C.A1)
# Update the recode + strand flip SNPs
com.snps <- bim$SNP %in% info.crecode$SNP
tmp <- bim[com.snps,]$B.A1
bim[com.snps,]$B.A1 <- as.character(sapply(bim[com.snps,]$B.A2, complement))
bim[com.snps,]$B.A2 <- as.character(sapply(tmp, complement))

# Output updated bim file
write.table(
    bim[,c("SNP", "B.A1")],
    "POST.a1",
    quote = F,
    row.names = F,
    col.names = F,
    sep="\t"
) #693499

mismatch <-
    bim$SNP[!(bim$SNP %in% info.match$SNP |
                bim$SNP %in% info.complement$SNP | 
                bim$SNP %in% info.recode$SNP |
                bim$SNP %in% info.crecode$SNP)]
write.table(
    mismatch,
    "POST.mismatch",
    quote = F,
    row.names = F,
    col.names = F
) #25675
q() # exit R

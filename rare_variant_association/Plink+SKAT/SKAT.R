library(SKAT)
setwd("/home/syjoo/SKAT")
#version rare
file_name <- "rare_2"

File.Bed <- paste(file_name,".bed",sep = "") #
File.Bim <- paste(file_name,"2.bim",sep = "") #
File.Fam <- paste(file_name,".fam",sep = "") #
File.SSD <- paste(file_name,".SSD",sep = "") 
File.Info <- paste(file_name,".info",sep = "")
File.SetID <- paste(file_name,".SetID",sep = "") #

Generate_SSD_SetID(File.Bed, File.Bim, File.Fam, File.SetID, File.SSD, File.Info)
#genotype <- Get_Genotypes_SSD(File.Info, SET_ID, is_ID = TRUE)
#Check duplicated SNPs in each SNP set
#No duplicate
#Warning: SSD file has more SNP sets then SetID file.It happens when SNPs in sets are not contiguous!
#SKAT generates a temporary SetID file with contiguous SNP sets. However the order of SNP sets will be different from the order of SNP sets in the original SetID file!
#Check duplicated SNPs in each SNP set
#No duplicate
#118 Samples, 46946 Sets, 3817058 Total SNPs

SSD.INFO <- Open_SSD(File.SSD, File.Info)
FAM <- Read_Plink_FAM(File.Fam, Is.binary=TRUE)
# continuous phenotype
#obj <- SKAT_Null_Model(y ~ covariates, out_type="C")
# dichotomous phenotype
obj <- SKAT_Null_Model(Phenotype ~ Sex, out_type="D", data=FAM)
#Generate and open SSD file for analysis
SSD.INFO <- Open_SSD(File.SSD,File.Info)
# SKAT
out.skat <- SKATBinary.SSD.All(SSD.INFO, obj)
out.skat.results <- out.skat$results
QQPlot_Adj(out.skat.results$P.value, out.skat.results$MAP, main="QQ plot", ntry=500, confidence=0.95, Is.unadjsted=TRUE
, Is.legend=TRUE, xlab="Expected Quantiles (-log10 P-values)"
, ylab="Observed Quantiles (-log10 P-values)")
#SKAT-O
out.skato <- SKAT.SSD.All(SSD.INFO, obj, method="optimal")
#Burden test
out.burden <- SKAT.SSD.All(SSD.INFO, obj, r.corr=1)
write.table(out.skat$results,"SKAT_results_rare.txt",col.names=T,row.names=F,quote=F,sep="\t")
Close_SSD()

library(SKAT)

File.Bed<-'./Example1.bed'
File.Bim<-'./Example1.bim'
File.Fam<-'./Example1.fam'
File.SetID<-'./Example1.SetID'

#Calling covariate file (Order of the sample ID must be same with the fam file)
#When there is no covariate file, use FAM<-Read_Plink_FAM(File.Fam,Is.binary = F) 
#and object obj<-SKAT_Null_Model(y~X1+X2, out_type = 'C')
File.Cov<-'./Example1.Cov'
FAM_Cov<-Read_Plink_FAM_Cov(File.Fam,File.Cov,Is.binary = F)

#Object file for Null model
obj<-SKAT_Null_Model(Phenotype~X1+X2, data=FAM_Cov, out_type = 'C')

# If the phenotype is binary one, out_type='D'
# for dichotomous phenotype
#obj <- SKAT_Null_Model(y ~ covariates, out_type="D")
#When there is no covariate file, use FAM<-Read_Plink_FAM(File.Fam,Is.binary = F) 
#and object obj<-SKAT_Null_Model(y~1, out_type = 'C')

#Please set file location and name for SSD file and SSD.info file 
File.SSD<-'./Example1.SSD'
File.Info<-'./Example1.SSD.info'

#Generate and open SSD file for analysis
Generate_SSD_SetID(File.Bed,File.Bim,File.Fam,File.SetID,File.SSD,File.Info )
SSD.INFO<-Open_SSD(File.SSD,File.Info)
SSD.INFO$nSample
SSD.INFO$nSets

#Analysis
out<-SKAT.SSD.All(SSD.INFO,obj,method='SKATO')
#close SSD file 
Close_SSD()

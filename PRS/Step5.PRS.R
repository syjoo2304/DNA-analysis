valid <- read.table("POST.valid.sample", header=T)
dat <- read.table("POST.QC.sexcheck", header=T)
valid <- subset(dat, STATUS=="OK" & FID %in% valid$FID)
write.table(valid[,c("FID", "IID")], "POST.QC.valid", row.names=F, col.names=F, sep="\t", quote=F) 
q() # exit R

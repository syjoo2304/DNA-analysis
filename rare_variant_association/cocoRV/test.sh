mkdir -p /home/syjoo/test/cocorv/KOVA/KOVA_005

controlGDSFile="/home/syjoo/test/cocorv/KOVA/test.vcf.gz.gds"
caseGDSFile="/home/syjoo/test/cocorv/BamToBW_YUHL/sample.annotated.GT.no_chr.vcf.gz.gds"
sampleList="/home/syjoo/test/cocorv/BamToBW_YUHL/YUHL_CASE.txt"
bed="/home/syjoo/test/cocorv/BamToBW_YUHL/BED/YUHL.coverage10x_remov_edit.bed.gz"
variantExcludeFile="/home/syjoo/test/cocorv/KOVA/lcr.KOVAoverlap.final3.txt.gz"
AFMax=5e-3
maxAFPopmax=1
variantMissing=0.1
ACANConfig="../example/1KG/stratified_config_KOVA_EAS.txt"
caseGroup="/home/syjoo/test/cocorv/BamToBW_YUHL/YUHL_ethnicity.txt"
variantGroup="annovar_pathogenic" 
minREVEL=0.65
pLDControl=0.05
highLDVariantFile="../example/1KG/full_vs_gnomAD.p0.05.OR1.ignoreEthnicityInLD.rds"
outputPrefix=/home/syjoo/test/cocorv/KOVA/KOVA_005/AFMax${AFMax}.${variantGroup}.${REVELThreshold}.excludeV3.LDv2
removeStar=T
checkHighLDInControl=T
fullCaseGenotype=T

Rscript ../utilities/CoCoRV_wrapper.R \
  --sampleList ${sampleList} \
  --outputPrefix ${outputPrefix} \
  --AFMax ${AFMax} \
  --maxAFPopmax ${maxAFPopmax} \
  --bed ${bed} \
  --variantMissing ${variantMissing} \
  --variantGroup ${variantGroup} \
  --removeStar \
  --ACANConfig ${ACANConfig} \
  --caseGroup ${caseGroup} \
  --minREVEL ${minREVEL} \
  --variantExcludeFile ${variantExcludeFile}  \
  --checkHighLDInControl \
  --pLDControl ${pLDControl} \
  --highLDVariantFile ${highLDVariantFile} \
  --fullCaseGenotype \
  ${controlCount} \
  ${caseCount}

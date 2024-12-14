#!/bin/bash

mkdir -p [path_to_output]

controlGDSFile="[path_to_customized_control_gds]/KOVA2.vcf.gz.gds"
caseGDSFile="[path_to_case_gds]/sample.annotated.GT.no_chr.vcf.gz.gds"
sampleList="[path_to_samplelist]/YUHL_CASE.txt"
bed="[path_to_bedfile]/YUHL.coverage10x_remov_edit.bed.gz"
variantExcludeFile="[path_to_lcr]/lcr.KOVAoverlap.final3.txt.gz"
AFMax=5e-3 #up to your choice
maxAFPopmax=1 #up to your choice
variantMissing=0.1 #up to your choice
ACANConfig="[path_to_customized_control_config_file]/stratified_config_KOVA_EAS.txt"
caseGroup="[path_to_case_phenotype_file]/YUHL_ethnicity.txt"
variantGroup="annovar_pathogenic" #up to your choice
minREVEL=0.65 #up to your choice
pLDControl=0.05 #up to your choice
highLDVariantFile="../example/1KG/full_vs_gnomAD.p0.05.OR1.ignoreEthnicityInLD.rds" # Used what developer offered.
outputPrefix="[path_to_output]"/AFMax${AFMax}.${variantGroup}.${REVELThreshold}.excludeV3.LDv2
removeStar=T #up to your choice
checkHighLDInControl=T #up to your choice
fullCaseGenotype=T #up to your choice

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

#!/bin/bash
# case
vcfAnnotated="[path_to_case_vcf]/sample.annotated.GT.no_chr.vcf.gz"
Rscript ../utilities/vcf2gds.R ${vcfAnnotated} ${vcfAnnotated}.gds 4
# control
gnomADAnnotated="[path_to_control_vcf]/KOVA2.vcf.gz"
Rscript ../utilities/vcf2gds.R ${gnomADAnnotated} ${gnomADAnnotated}.gds 4

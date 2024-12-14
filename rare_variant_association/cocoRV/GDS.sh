#!/bin/bash
# case
vcfAnnotated=/home/syjoo/test/cocorv/BamToBW_YUHL/sample.annotated.GT.no_chr.vcf.gz
Rscript ../utilities/vcf2gds.R ${vcfAnnotated} ${vcfAnnotated}.gds 4
# control
gnomADAnnotated="/home/syjoo/test/cocorv/KOVA/test.vcf.gz"
Rscript ../utilities/vcf2gds.R ${gnomADAnnotated} ${gnomADAnnotated}.gds 4

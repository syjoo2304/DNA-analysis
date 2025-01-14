import os,sys,string

def batch1_gatk(sample_name):
	name=sample_name
	fastq1=name+'_1.fastq.gz'
	fastq2=name+'_2.fastq.gz'
	ref='/home/syjoo/REF/Human/hg38/hg38_vgatk/v0/Homo_sapiens_assembly38.fasta'
	picard='/opt/picard/2.25.6/build/libs/picard.jar'
	dbsnp='/home/syjoo/REF/Human/hg38/hg38_vgatk/v0/Homo_sapiens_assembly38.dbsnp138.vcf'

	print('step 1-1/3 - bwa, samtools')
	# -R "@RG\\tPL:Illumina\\tID:YUHL\\tSM:'+Sample+'\\tLB:HiSeq"

	os.system('bwa mem -M -t 2 \
		-R "@RG\\tID:YUHL\\tSM:'+name+'\\tLB:HiSeq\\tPL:ILLUMINA" \
		'+ref+' \
		'+fastq1+' \
		'+fastq2+' | \
		samtools view -b -h -o '+name+'.bam -')

	print('step 1-2/3 - sortsam')

	os.system('java -Xmx7g -jar '+picard+' SortSam \
		I='+name+'.bam \
		O='+name+'.sort.bam \
		VALIDATION_STRINGENCY=LENIENT \
		SORT_ORDER=coordinate \
		MAX_RECORDS_IN_RAM=3000000 \
		CREATE_INDEX=True')

	print('step 1-3/3 - markduplicates')

	os.system('java -Xmx7g -jar '+picard+' MarkDuplicates \
		I='+name+'.sort.bam \
		O='+name+'.sort.dup.bam \
		METRICS_FILE='+name+'.marked_dup_metrics.txt')

	print('step 2-1/2 -baserecalibrator')
	os.system('gatk --java-options "-Xmx7g" BaseRecalibrator \
		-I '+name+'.sort.dup.bam \
		-R '+ref+' \
		--known-sites '+dbsnp+' \
		-O '+name+'.recal_data.table')

	print('# step 2-2/2  -Apply the model to adjust the base quality scores')
	os.system('gatk --java-options "-Xmx7g" ApplyBQSR \
		-I '+name+'.sort.dup.bam \
		-R '+ref+' \
		--bqsr-recal-file '+name+'.recal_data.table \
		-O '+name+'.sort.dup.bqsr.bam')

	print('#step 3-1/1 -variant calling by haplotypecaller')
	os.system('gatk --java-options "-Xmx7g" HaplotypeCaller \
		-I '+name+'.sort.dup.bqsr.bam \
		-R '+ref+' \
		-ERC GVCF \
		-O '+name+'.g.vcf.gz')

	print('#step 4-1/2 - combine multiple gVCFs to cohort VCF')
	print('#step 4-2/2 - genotyping gVCF')
	#os.system('gatk --java-options "-Xmx7g" GenotypeGVCFs \
	#	-R '+ref+' \
	#	-V '+name+'.'+chr_+'.g.vcf.gz \
	#	-O '+name+'.'+chr_+'.output.vcf.gz')


filename=os.listdir('.')
fqname=[i for i in filename if i.endswith('_1.fastq.gz')]

for i in fqname:
	name=i.split('_1.fastq.gz')[0]
	print('##processing: '+name)
	batch1_gatk(name)

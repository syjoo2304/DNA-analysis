##this script originates from /home/syjoo/test/Mito

import os,glob,string,sys,json
from collections import OrderedDict

file_data = OrderedDict()

bamm_list=glob.glob('*.bam')
print(bamm_list)

dir_t = os.getcwd()

if not os.path.isdir('Mito_Analysis'):
	os.mkdir('Mito_Analysis')	


for i in bamm_list:
        name=i.split('_dedup.bam')[0]
        print(name)
        file_data["MitochondriaPipeline.wgs_aligned_input_bam_or_cram"]= name+"_dedup.bam"
        file_data["MitochondriaPipeline.wgs_aligned_input_bam_or_cram_index"]= name+"_dedup.bai"
        file_data["MitochondriaPipeline.ref_fasta"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/Homo_sapiens_assembly38.fasta"
        file_data["MitochondriaPipeline.ref_dict"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/Homo_sapiens_assembly38.dict"
        file_data["MitochondriaPipeline.ref_fasta_index"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/Homo_sapiens_assembly38.fasta.fai"
        file_data["MitochondriaPipeline.mt_dict"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/Homo_sapiens_assembly38.chrM.dict"
        file_data["MitochondriaPipeline.mt_fasta"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/Homo_sapiens_assembly38.chrM.fasta"
        file_data["MitochondriaPipeline.mt_fasta_index"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/Homo_sapiens_assembly38.chrM.fasta.fai"
        file_data["MitochondriaPipeline.mt_amb"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/Homo_sapiens_assembly38.chrM.fasta.amb"
        file_data["MitochondriaPipeline.mt_ann"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/Homo_sapiens_assembly38.chrM.fasta.ann"
        file_data["MitochondriaPipeline.mt_bwt"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/Homo_sapiens_assembly38.chrM.fasta.bwt"
        file_data["MitochondriaPipeline.mt_pac"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/Homo_sapiens_assembly38.chrM.fasta.pac"
        file_data["MitochondriaPipeline.mt_sa"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/Homo_sapiens_assembly38.chrM.fasta.sa"
        file_data["MitochondriaPipeline.blacklisted_sites"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/blacklist_sites.hg38.chrM.bed"
        file_data["MitochondriaPipeline.blacklisted_sites_index"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/blacklist_sites.hg38.chrM.bed.idx"
        file_data["MitochondriaPipeline.mt_shifted_dict"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/Homo_sapiens_assembly38.chrM.shifted_by_8000_bases.dict"
        file_data["MitochondriaPipeline.mt_shifted_fasta"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/Homo_sapiens_assembly38.chrM.shifted_by_8000_bases.fasta"
        file_data["MitochondriaPipeline.mt_shifted_fasta_index"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/Homo_sapiens_assembly38.chrM.shifted_by_8000_bases.fasta.fai"
        file_data["MitochondriaPipeline.mt_shifted_amb"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/Homo_sapiens_assembly38.chrM.shifted_by_8000_bases.fasta.amb"
        file_data["MitochondriaPipeline.mt_shifted_ann"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/Homo_sapiens_assembly38.chrM.shifted_by_8000_bases.fasta.ann"
        file_data["MitochondriaPipeline.mt_shifted_bwt"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/Homo_sapiens_assembly38.chrM.shifted_by_8000_bases.fasta.bwt"
        file_data["MitochondriaPipeline.mt_shifted_pac"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/Homo_sapiens_assembly38.chrM.shifted_by_8000_bases.fasta.pac"
        file_data["MitochondriaPipeline.mt_shifted_sa"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/Homo_sapiens_assembly38.chrM.shifted_by_8000_bases.fasta.sa"
        file_data["MitochondriaPipeline.shift_back_chain"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/ShiftBack.chain"
        file_data["MitochondriaPipeline.control_region_shifted_reference_interval_list"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/control_region_shifted.chrM.interval_list"
        file_data["MitochondriaPipeline.non_control_region_interval_list"]="/home/syjoo/program/Mito/gatk4-mitochondria-pipeline/reference/chrM/non_control_region.chrM.interval_list"
#        print(json.dumps(file_data, ensure_ascii=False, indent="\t"))

        with open('ExampleInputsMitochondriaPipeline'+name+'.json','w') as make_file:
                json.dump(file_data, make_file)
	

        os.system('mv *.json '+dir_t+'/Mito_Analysis')
        os.system('java -jar /home/syjoo/program/Mito/cromwell-57.jar run /home/syjoo/program/Mito/gatk4-mitochondria-pipeline/MitochondriaPipeline.wdl --inputs '+dir_t+'/Mito_Analysis/ExampleInputsMitochondriaPipeline'+name+'.json')

import os,sys,string,glob
##path to bam file
path='/home/DATA/YUHL/WGS/FASTQ/WGS_11/BAM_11/'

path_filelist=os.listdir(path)
path_bamlist=[i for i in path_filelist if i.endswith('_dedup.bam')]

##make symlinks of target bam file

Sample_list = []

for i in path_bamlist:
	sn=string.split(i,'_dedup.bam')[0]
	os.system('ln -s '+path+sn+'_dedup.bam .')
	os.system('ln -s '+path+sn+'_dedup.bai .')
	Sample_list.append(sn)

co,cnt=0,0
for fname in Sample_list:
	co+=1
        os.system('python /home/syjoo/program/manta-1.6.0.centos6_x86_64/bin/configManta.py \
                        --bam '+fname+'_dedup.bam --runDir ./'+fname+' \
                        --reference /home/syjoo/REF/Human/hg38/hg38/Homo_sapiens_assembly38.fasta')
	print co,'in',len(Sample_list),' input name:',fname,' done! -First Step'
	
for name in Sample_list:
	cnt+=1
        os.system('python ./'+name+'/runWorkflow.py -j 4')
	print cnt,'in',len(Sample_list),' input name:',name,' done! -Last Step'


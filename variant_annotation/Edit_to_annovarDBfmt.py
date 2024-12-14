import os,sys,string,gzip
#Chr    Start   End     Ref     Alt     AF
#'1', '160034085', '160034092', 'rs563137087', '.', 'CTTTCAT', 'C', '.',
#MT      647     647     A       G
vcfgz=gzip.open('tommo-60kjpn-20240904-GRCh38-snvindel-af-autosome.vcf.gz','rb')
bed=open('tommo.avinput','r')
bedout=open('tommo_annov.bed','w')
bedout.write('#Chr'+'\t'+'Start'+'\t'+'End'+'\t'+'Ref'+'\t'+'Alt'+'\t'+'ToMMo_AF'+'\n')

BED=[]

for line in bed:
	line_temp=line[:-1].split('\t')
	BED.append(line_temp[:5])

co=0
for line in vcfgz:
	if not line.startswith('#'):
		line_temp=line[:-1].split('\t')
		DVDOUT=string.split(line_temp[-1],';')
		for i in DVDOUT:
			info_=string.split(i,'=')
			if info_[0] == 'AF' :
				if ',' in info_[1]:
					tmp=string.split(info_[1],',')
					for i in tmp:
						tommoaf = i
						bedout.write('\t'.join(BED[co])+'\t'+i+'\n')
						co+=1
				else:
					tommoaf = info_[1]
					bedout.write('\t'.join(BED[co])+'\t'+tommoaf+'\n')
					co+=1
bedout.close()

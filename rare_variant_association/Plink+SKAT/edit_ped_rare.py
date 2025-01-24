import os,sys,string

file_lis=os.listdir('/home/syjoo/Project/EWAS_pre/VCF/Batch_early')
ctrl_lis=[]

for i in file_lis:
	if i.startswith('sample_YUHL'):
		if i.endswith('.vcf.gz'):
			file_name=string.split(i,'.g.vcf.gz')[0]
			ctrl_lis.append(file_name)

print(ctrl_lis)

pheno_lis={}
with open('/home/syjoo/REF/PHE/Total_re_final2.ped','r') as pheno:
	pheno.readline()
	for line in pheno:
		line_temp=line[:-1].split(' ')
		if not line_temp[0] in pheno_lis.keys():
			pheno_lis[line_temp[0]]=[0,0]
		pheno_lis[line_temp[0]][0]=line_temp[-2]
		pheno_lis[line_temp[0]][1]=line_temp[-1]
		


with open('rare.ped','r') as ped, open('rare_2.ped','w') as ped_new:
	for line in ped:
		line_temp=line.split(' ')
		try:
			sex=pheno_lis[line_temp[0]][0]
			disease=pheno_lis[line_temp[0]][1]
			ped_new.write(' '.join(line_temp[:4])+' '+sex+' '+disease+' '+' '.join(line_temp[6:]))			

		except KeyError:
			print(line_temp[0])

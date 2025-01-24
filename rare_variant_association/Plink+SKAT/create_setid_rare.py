import os,sys,string

with open('rare_2.SetID','w') as setid, open('filtered6.rare.vcf') as source:
	for line in source:
		if not line.startswith('#'):
			line_temp=line[:-1].split('\t')
			ID=line_temp[0]+':'+line_temp[1]+'_'+line_temp[3]+'/'+line_temp[4]
			info_=string.split(line_temp[7],';')
			for i in info_:
				if 'Gene.refGene' in i:
					gene=string.split(i,'=')[1]
					break
			setid.write(gene+' '+ID+'\n')


import os,sys,string

gender={}
phenotype={}

with open('ARHL.fam','r') as fp:
        for line in fp:
                line_temp=line.strip().split('\t')
                gender[line_temp[0]]=line_temp[-2]
                phenotype[line_temp[0]]=line_temp[-1]


with open('ARHL_23_e.fam','w') as out, open('ARHL_v23.fam','r') as read:
        for line in read:
                new=[]
                line_temp=line.strip().split(' ')
                new=line_temp[:-2]
                gen=gender[line_temp[0]]
                phe=phenotype[line_temp[0]]
                new.insert(len(new),gen)
                new.insert(len(new),phe)
                out.write(' '.join(new)+'\n')

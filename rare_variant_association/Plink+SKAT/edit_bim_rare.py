import os,sys,string

with open('rare_2.SetID','r') as setid:
	lis=[]
	for line in setid:
		line_temp=line[:-1].split(' ')
		lis.append(line_temp[1])

with open('rare_2.bim','r') as bim, open('rare_22.bim','w') as bim2:
	co=0
	for line in bim:
		line_temp=line[:-1].split('\t')
		bim2.write(line_temp[0]+'\t'+lis[co]+'\t'+'\t'.join(line_temp[2:])+'\n')
		co+=1
		

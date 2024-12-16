mport os,sys,string

with open('ARHL_23_e.bim','w') as bim, open('ARHL_v23.bim','r') as bim_:
        for line in bim_:
                line_temp=line.strip().split('\t')
                new_id=line_temp[0]+':'+':'.join(line_temp[3:])
                line_temp[1]=new_id
                bim.write('\t'.join(line_temp)+'\n')

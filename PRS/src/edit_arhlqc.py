import os,sys,string

with open('backup/ARHL.QC2','w') as out, open('ARHL.QC','r') as fp:
        hd=next(fp)
        out.write(hd)
        for line in fp:
                line_temp=line.strip().split('\t')
                line_temp[2]=line_temp[0]+':'+line_temp[1]+':'+':'.join(line_temp[3:5])
                out.write(' '.join(line_temp)+'\n')

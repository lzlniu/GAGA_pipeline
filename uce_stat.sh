#!/bin/bash
#author:Zelin Li
#date:2021/09/24

workdict='/home/people/zelili/zhanglab/GAGA/'
phylucedict='/home/projects/ku_00039/people/zelili/programs/miniconda2/envs/phyluce-1.7.1/bin/'
cd $workdict

# get uce number through '>' of each fasta and sort them
grep -c '>' ant*/*.fasta | awk -F ':' '{print $2,$1}' | awk -F '/' '{print $1}' | sort -k 1n > ucenumber.txt

# get ant genome tag name and uce statistics
for i in $(awk -F ' ' '{print $2}' ucenumber.txt); do 
	ls $i/*.tab | awk -F '/' '{print $2}' | sed -e 's/_sizes.tab//g' >> anttagname.txt
	${phylucedict}phyluce_assembly_get_fasta_lengths --input $i/${i}.fasta --csv >> ucestat.txt
done

# combine two files column
awk -F ',' 'NR==FNR{array_row[NR]=$0;row_num=NR;} NR>FNR{print array_row[NR-row_num], $0}' ucestat.txt anttagname.txt > uce_stat.txt
sed -i 's/,/ /g' uce_stat.txt
sed -i 's/.fasta//g' uce_stat.txt
rm -rf anttagname.txt
rm -rf ucestat.txt
rm -rf ucenumber.txt

#du -s ant*/*.fasta | awk '{print $1}' | awk '{sum+=$1}END{print sum/1048576}'

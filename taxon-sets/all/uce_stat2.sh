#!/bin/bash
#author:Zelin Li
#date:2021/09/24

workdict=$(pwd)
phylucedict='/home/projects/ku_00039/people/zelili/programs/miniconda2/envs/phyluce-1.7.1/bin/'
cd $workdict

# get uce number through '>' of each fasta and sort them
grep -c '>' exploded-fastas/*.fasta | awk -F ':' '{print $2,$1}' | sort -k 1n | awk -F '/' '{print $NF}' | sed -e 's/.unaligned.fasta//g' > ucerank.txt

# get ant genome tag name and uce statistics
for i in $(cat ucerank.txt); do 
	ls ../../$i/*.tab | awk -F '/' '{print $NF}' | sed -e 's/_sizes.tab//g' >> anttagname.txt
	${phylucedict}phyluce_assembly_get_fasta_lengths --input exploded-fastas/${i}.unaligned.fasta --csv >> ucestat.txt
done

# combine two files column
awk -F ',' 'NR==FNR{array_row[NR]=$0;row_num=NR;} NR>FNR{print array_row[NR-row_num], $0}' ucestat.txt anttagname.txt > uce_stat2.txt
sed -i 's/,/ /g' uce_stat2.txt
sed -i 's/.unaligned.fasta//g' uce_stat2.txt
rm -rf anttagname.txt
rm -rf ucestat.txt
rm -rf ucerank.txt

# add first line as 'samples contigs total_bp mean_length 95_CI_length min_length max_length median_legnth contigs samples_name'
#du -s ant*/*.fasta | awk '{print $1}' | awk '{sum+=$1}END{print sum/1048576}'

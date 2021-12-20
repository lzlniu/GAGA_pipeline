#!/bin/bash
#author:Zelin Li (zelin.li@cpr.ku.dk)
#date:2021.11.19

# For each specific UCE, find the ant(s) number that don't have this UCE
#uce_num=$1 #input

workdict="/home/people/zelili/zhanglab/GAGA/taxon-sets/all/exploded-fastas"
outname="miss_uce_ants_test4.txt"
cd $workdict

#seq 1 163 > file2 # for compare
touch $workdict/$outname # create file
for uce_num in $(grep ">" ${workdict}/*.fasta | awk -F "/" '{print $NF}' | awk -F "-" '{print $3}' | sort -n | uniq); do
	echo "uce-${uce_num} " >> $workdict/$outname # set uce_num as first column, if un-comment and don't use following line of echo, then it should be echo -ne
	echo -ne `grep "uce-${uce_num}_ant" ${workdict}/*.fasta | awk -F "ant" '{print $NF}' | awk -F ' ' '{print $1}' | sort -n` >> $workdict/$outname
<<'COMMENT'
	grep "uce-${uce_num}_ant" ${workdict}/*.fasta | awk -F "ant" '{print $NF}' | awk -F ' ' '{print $1}' | sort -n > file1
	cat file1 file2 | sort | uniq -d > filetmp
	cat file2 filetmp | sort -n | uniq -u > filediff
	for i in $(cat file2); do
		#echo -ne "," >> $workdict/miss_uce_ants.csv # because want csv format
		let count=0
		for j in $(cat filediff); do
			if [ $i == $j ]; then
				let count=count+1
				echo -ne "0" >> $workdict/$outname # if the ant (file) don't have the uce, then record it
			fi
		done
		if [ $count == 0 ] ; then
			echo -ne "-" >> $workdict/$outname
		fi
	done
	echo " " >> $workdict/$outname # change to a new row
COMMENT
done
sed -i '/^$/d' $workdict/$outname #delete empty row
#rm -rf file1 file2 filetmp filediff

# Next is to


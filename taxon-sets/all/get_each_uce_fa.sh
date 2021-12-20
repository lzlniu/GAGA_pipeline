#!/bin/bash
#author:Zelin Li (zelin.li@cpr.ku.dk)
#date:2021/11/29

workdict="/home/people/zelili/zhanglab/GAGA/taxon-sets/all"
inputfile="all-taxa-incomplete.fasta"
cd $workdict
outputdict="$workdict/exploded-uces-fastas"

if [ ! -f $workdict/oneline_$inputfile ]; then
	awk '{if($0~/>/) name=$0; else seq[name]=seq[name]$0;}END{for(i in seq) print i"\n"seq[i]}' $workdict/$inputfile > $workdict/oneline_$inputfile
fi
if [ ! -d $outputdict ]; then
	mkdir $outputdict
	for uce_num in $(grep ">" ${workdict}/oneline_${inputfile} | awk -F "/" '{print $NF}' |  awk -F "-" '{print $3}' | sort -n | uniq); do
		#echo -e "#!/bin/bash\n#PBS -N ${uce_num}\n#PBS -e ucefasta_err.log\n#PBS -o ucefasta_out.log\ngrep -A 1 "uce-${uce_num}_ant" ${workdict}/oneline_${inputfile} > $outputdict/oneline_uce-${uce_num}.fasta\nsed -i '/--/d' $outputdict/oneline_uce-${uce_num}.fasta" > $outputdict/ucefasta_tmp.sh
		#qsub $outputdict/ucefasta_tmp.sh
		grep -A 1 "uce-${uce_num}_ant" ${workdict}/oneline_${inputfile} > $outputdict/oneline_uce-${uce_num}.fasta
		sed -i '/--/d' $outputdict/oneline_uce-${uce_num}.fasta
	done
	#rm -rf $outputdict/ucefasta_tmp.sh
	#sed -i '/--/d' $outputdict/oneline_uce*.fasta
fi

mafft="/home/projects/ku_00039/people/zelili/programs/mafft-7.490/bin/mafft"
if [ -d $outputdict ]; then
	for uce_fasta in $(ls $outputdict); do
		echo -e "#!/bin/bash\n#PBS -N ${uce_fasta}\n#PBS -e mafft_err.log\n#PBS -o mafft_out.log\n$mafft --auto $outputdict/$uce_fasta > $outputdict/aln_$uce_fasta" > $outputdict/mafft_tmp.sh
		qsub $outputdict/mafft_tmp.sh
	done
	rm -rf $outputdict/mafft_tmp.sh
fi

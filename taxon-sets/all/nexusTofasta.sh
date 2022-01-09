#!/bin/bash
#author:Zelin Li
#date:2022/01/09

workdict="/home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all"
indict="/home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/mafft-nexus-internal-trimmed-gblocks"
outdict="/home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/mafft-nexus-internal-trimmed-gblocks-fasta"

if [ ! -d $outdict ]; then
	mkdir $outdict
else
	rm -rf $outdict
	mkdir $outdict
fi

module load tools
module load ngs
module load anaconda3/4.4.0

for uce_num in $(ls ${indict}/*.nexus | awk -F '-' '{print $NF}' | awk -F '.' '{print $1}'); do
	python $workdict/nexusTofasta.py $indict/uce-${uce_num}.nexus $outdict/uce-${uce_num}.fasta
done


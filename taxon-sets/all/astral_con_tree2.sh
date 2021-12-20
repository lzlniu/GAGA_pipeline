#!/bin/bash
#PBS -N astral
#PBS -l walltime=240:00:00

#author:Zelin Li
#date:2021/12/18

astral_path="/home/people/zelili/zhanglab/programs/Astral/astral.5.7.8.jar"
trees_path="/home/people/zelili/zhanglab/GAGA/taxon-sets/all/exploded-uces-fastas"
work_path="/home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all"

innum=0.25
#min_in=`echo "163*$1" | bc`
min_in=`echo "163*$innum" | bc`
min_num=`printf '%.0f' $min_in`
out_dict="astral_out_ge$min_num"

if [ ! -d $work_path/$out_dict ]; then
	mkdir $work_path/$out_dict 
else
	rm -rf $work_path/$out_dict 
	mkdir $work_path/$out_dict 
fi

for i in $(ls ${trees_path}/tree_*.iqtree | awk -F '-' '{print $NF}' | awk -F '.' '{print $1}'); do
	# two counting species number methods
	((countA = `sed -e "s/uce-${i}_/\n/g" ${trees_path}/tree_uce-${i}.contree | awk -F ":" '{print $1}' | sort | uniq | wc -l` - 1))
	((countB = `grep "Input data: " ${trees_path}/tree_uce-${i}.iqtree | awk '{print $3}'`))
	if [ $countA != $countB ]; then
		printf "ERROR ----> uce-${i} have method-A (${countA}) equal to method-B (${countB})\n"
	fi
	if [ $countB -ge $min_num ]; then
		#printf "uce-${i}\t${countB}\n"
		sed -e "s/uce-${i}_//g" ${trees_path}/tree_uce-${i}.contree >> ${work_path}/$out_dict/all_contree.nwk
		sed -e "s/uce-${i}_//g" ${trees_path}/tree_uce-${i}.treefile >> ${work_path}/$out_dict/all_treefile.nwk
	fi
done
printf "UCE tree with less than $min_num ($min_in) species are excluded.\n"

module load tools
module load newick-utils/1.6
nw_ed ${work_path}/$out_dict/all_contree.nwk 'i & b <= 10' o > ${work_path}/$out_dict/all_contree_BootstrapCollapsed.nwk
nw_ed ${work_path}/$out_dict/all_treefile.nwk 'i & b <= 10' o > ${work_path}/$out_dict/all_treefile_BootstrapCollapsed.nwk

java -jar $astral_path -i ${work_path}/$out_dict/all_contree_BootstrapCollapsed.nwk -o ${work_path}/$out_dict/con_all_contree_BootstrapCollapsed.nwk
cp ${work_path}/$out_dict/con_all_contree_BootstrapCollapsed.nwk ${work_path}/$out_dict/cp_con_all_contree_BootstrapCollapsed.nwk
bash /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/tree_name.sh ${work_path}/$out_dict/cp_con_all_contree_BootstrapCollapsed.nwk
perl /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/get_treetaxas_assigncolors_subfamily.pl ${work_path}/$out_dict/cp_con_all_contree_BootstrapCollapsed.nwk

java -jar $astral_path -i ${work_path}/$out_dict/all_treefile_BootstrapCollapsed.nwk -o ${work_path}/$out_dict/con_all_treefile_BootstrapCollapsed.nwk
cp ${work_path}/$out_dict/con_all_treefile_BootstrapCollapsed.nwk ${work_path}/$out_dict/cp_con_all_treefile_BootstrapCollapsed.nwk
bash /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/tree_name.sh ${work_path}/$out_dict/cp_con_all_treefile_BootstrapCollapsed.nwk
perl /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/get_treetaxas_assigncolors_subfamily.pl ${work_path}/$out_dict/cp_con_all_treefile_BootstrapCollapsed.nwk


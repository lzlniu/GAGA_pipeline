#!/bin/bash
#PBS -N astral
#PBS -l walltime=240:00:00

#author:Zelin Li
#date:2021/12/16

astral_path="/home/people/zelili/zhanglab/programs/Astral/astral.5.7.8.jar"
trees_path="/home/people/zelili/zhanglab/GAGA/taxon-sets/all/exploded-uces-fastas"
work_path="/home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all"
out_dict="astral_out3"

if [ ! -d $work_path/$out_dict ]; then
	mkdir $work_path/$out_dict 
else
	rm -rf $work_path/$out_dict 
	mkdir $work_path/$out_dict 
fi

for i in $(ls ${trees_path}/tree_*.contree | awk -F '_' '{print $NF}' | awk -F '.' '{print $1}'); do
	sed -e "s/${i}_//g" ${trees_path}/tree_${i}.treefile >> ${work_path}/$out_dict/all_treefile.tre
done

java -jar $astral_path -i ${work_path}/$out_dict/all_treefile.tre -o ${work_path}/$out_dict/con_all_treefile.tre
cp ${work_path}/$out_dict/con_all_treefile.tre ${work_path}/$out_dict/cp_con_all_treefile.tre
bash /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/tree_name.sh ${work_path}/$out_dict/cp_con_all_treefile.tre
perl /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/get_treetaxas_assigncolors_subfamily.pl ${work_path}/$out_dict/cp_con_all_treefile.tre


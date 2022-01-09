#!/bin/bash
#PBS -N astral_onlycon
#PBS -l walltime=240:00:00

#author:Zelin Li
#date:2021/12/18

astral_path="/home/people/zelili/zhanglab/programs/Astral/astral.5.7.8.jar"
#trees_path="/home/people/zelili/zhanglab/GAGA/taxon-sets/all/exploded-uces-fastas"
work_path="/home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all"

innum=0.25
#min_in=`echo "163*$1" | bc`
min_in=`echo "163*$innum" | bc`
min_num=`printf '%.0f' $min_in`
out_dict="astral_out_ge$min_num"

for i in `seq 1 2`; do
	((m = $i*10))
	for j in contree treefile; do
		echo "#!/bin/bash
#PBS -N as_${j}_bc${m}
#PBS -l walltime=240:00:00
module load tools
module load newick-utils/1.6
nw_ed ${work_path}/${out_dict}/all_${j}.nwk 'i & b <= ${m}' o > ${work_path}/${out_dict}/all_${j}_bc${m}.nwk
java -jar ${astral_path} -i ${work_path}/${out_dict}/all_${j}_bc${m}.nwk -o ${work_path}/${out_dict}/con_all_${j}_bc${m}.nwk
cp ${work_path}/${out_dict}/con_all_${j}_bc${m}.nwk ${work_path}/${out_dict}/cp_con_all_${j}_bc${m}.nwk
bash /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/tree_name.sh ${work_path}/${out_dict}/cp_con_all_${j}_bc${m}.nwk
perl /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/get_treetaxas_assigncolors_subfamily.pl ${work_path}/${out_dict}/cp_con_all_${j}_bc${m}.nwk" > ${work_path}/run_astral_onlycon.sh
		qsub ${work_path}/run_astral_onlycon.sh
	done
done


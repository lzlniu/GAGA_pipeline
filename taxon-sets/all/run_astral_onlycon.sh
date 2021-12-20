#!/bin/bash
#PBS -N as_treefile_bc90
#PBS -l walltime=240:00:00
module load tools
module load newick-utils/1.6
nw_ed /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/astral_out_ge41/all_treefile.nwk 'i & b <= 90' o > /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/astral_out_ge41/all_treefile_bc90.nwk
java -jar /home/people/zelili/zhanglab/programs/Astral/astral.5.7.8.jar -i /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/astral_out_ge41/all_treefile_bc90.nwk -o /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/astral_out_ge41/con_all_treefile_bc90.nwk
cp /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/astral_out_ge41/con_all_treefile_bc90.nwk /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/astral_out_ge41/cp_con_all_treefile_bc90.nwk
bash /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/tree_name.sh /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/astral_out_ge41/cp_con_all_treefile_bc90.nwk
perl /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/get_treetaxas_assigncolors_subfamily.pl /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/astral_out_ge41/cp_con_all_treefile_bc90.nwk

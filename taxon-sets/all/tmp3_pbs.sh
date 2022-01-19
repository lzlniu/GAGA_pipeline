#!/bin/sh
#PBS -W group_list=ku_00039 -A ku_00039
#PBS -N tmp3
#PBS -e tmp3.err
#PBS -o tmp3.log
#PBS -m n
#PBS -l nodes=1:ppn=1
#PBS -l mem=20gb
#PBS -l walltime=24:00:00
#PBS -X

echo Working directory is /home/people/zelili/zhanglab/GAGA/taxon-sets/all
cd /home/people/zelili/zhanglab/GAGA/taxon-sets/all

module load tools
module load ngs
module load anaconda3/4.4.0
module load perl
module load trimal/1.4.1
module load muscle/3.8.425
module load iqtree/2.1.2

iqtree2 -s /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/mafft-nexus-internal-trimmed-gblocks-clean-75p-raxml/topology.phylip --prefix final_tree -g /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/data/astral_out_ge41/cp_con_all_contree_bc20.nwk


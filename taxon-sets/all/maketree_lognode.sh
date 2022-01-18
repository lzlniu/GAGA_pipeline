#!/bin/sh
#PBS -W group_list=ku_00039 -A ku_00039
##PBS -N maketree_tmp
#PBS -e maketree.err
#PBS -o maketree.log
#PBS -m n
#PBS -l nodes=1:ppn=40
#PBS -l mem=180gb
#PBS -l walltime=240:00:00
#PBS -X

workdir=$(pwd)
echo Working directory is $workdir
cd $workdir

in=$1
topo=$2
out=$3

module load tools
module load ngs
module load anaconda3/4.4.0
module load perl
module load trimal/1.4.1
module load muscle/3.8.425
module load iqtree/2.1.2

echo modules loaded
cp $in/*.phylip $in/topology.phylip
echo phylip copied
bash /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/tree_name.sh $in/topology.phylip
echo phylip ants name renamed
iqtree2 -s ${in}/topology.phylip --prefix ${out} -g ${topo} -T 40 --safe
#iqtree2 -s ${in}/topology.phylip --prefix ${out} -g ${topo} -B 1000 -m MFP -T 40 --safe
rm -rf $in/topology.phylip
echo phylip removed

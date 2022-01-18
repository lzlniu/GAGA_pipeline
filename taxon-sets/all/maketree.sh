#!/bin/sh
### Note: No commands may be executed until after the #PBS lines
### Account information
#PBS -W group_list=ku_00039 -A ku_00039
### Job name (comment out the next line to get the name of the script used as the job name)
##PBS -N test
### Output files (comment out the next 2 lines to get the job name used instead)
##PBS -e test.err
##PBS -o test.log
### Only send mail when job is aborted or terminates abnormally
#PBS -m n
### Number of nodes
#PBS -l nodes=1:ppn=40
### Memory
#PBS -l mem=180gb
### Requesting time - format is <days>:<hours>:<minutes>:<seconds> (here 12:00:00, 12 hours)
#PBS -l walltime=240:00:00
### Forward X11 connection (comment out if not needed)
##PBS -X

# Go to the directory from where the job was submitted (initial directory is $HOME)
#echo Working directory is $PBS_O_WORKDIR
#cd $PBS_O_WORKDIR

workdir=$(pwd)
echo Working directory is $workdir
cd $workdir

#in=${PBS_O_WORKDIR}/mafft-nexus-internal-trimmed-gblocks-clean-75p-raxml/mafft-nexus-internal-trimmed-gblocks-clean-75p-raxml.phylip
in=$1
topo=$2
out=$3

### Here follows the user commands:
# Define number of processors
#NPROCS=`wc -l < $PBS_NODEFILE`
#echo This job has allocated $NPROCS nodes

# Load all required modules for the job
module load tools
module load ngs
module load anaconda3/4.4.0
module load perl
module load trimal/1.4.1
module load muscle/3.8.425
module load iqtree/2.1.2


# This is where the work is done
# Make sure that this script is not bigger than 64kb ~ 150 lines, otherwise put in seperat script and execute from here

#iqtree2 -s ${in} --prefix tree_b1000 -B 1000 -alrt 1000 -m MFP -T 40 --safe
echo "
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

echo Working directory is $workdir
cd $workdir

module load tools
module load ngs
module load anaconda3/4.4.0
module load perl
module load trimal/1.4.1
module load muscle/3.8.425
module load iqtree/2.1.2

echo modules loaded
#cp $in/*.phylip $in/topology.phylip
#echo phylip copied
#bash /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/tree_name.sh $in/topology.phylip
#echo phylip ants name renamed
#iqtree2 -s ${in}/topology.phylip --prefix ${out} -g ${topo} -T 40 --safe
iqtree2 -s ${in}/topology.phylip --prefix ${out} -g ${topo} -B 1000 -m MFP -T 40 --safe
#rm -rf $in/topology.phylip
#echo phylip removed
" > $workdir/maketree_tmp.sh
qsub < $workdir/maketree_tmp.sh

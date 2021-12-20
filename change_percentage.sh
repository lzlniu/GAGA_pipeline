#!/bin/bash
#PBS -W group_list=ku_00039 -A ku_00039
#PBS -N mainpipe
#PBS -e mainpipe.err
#PBS -o mainpipe.log
#PBS -m n
#PBS -l nodes=1:ppn=40,mem=120gb,walltime=96:00:00

# Go to the directory from where the job was submitted (initial directory is $HOME)
#echo Working directory is $PBS_O_WORKDIR
#cd $PBS_O_WORKDIR

### Here follows the user commands:
# define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes

#author:Zelin Li
#date:2021.11.12

workdict='/home/people/zelili/zhanglab/GAGA/'
phylucedict='/home/projects/ku_00039/people/zelili/programs/miniconda2/envs/phyluce-1.7.1/bin/'
probe='/home/people/zelili/zhanglab/GAGA/baits/hymenoptera-v2-ANT-SPECIFIC-uce-baits.fasta.txt'
probefile=`echo $probe | awk -F '/' '{print $NF}'`
percent='95'

# change to the taxon-sets/all directory
cd ${workdict}taxon-sets/all

# the integer following --taxa is the number of TOTAL taxa
# and I use "75p" to denote the 75% complete matrix
${phylucedict}phyluce_align_get_only_loci_with_min_taxa \
    --alignments mafft-nexus-internal-trimmed-gblocks-clean \
    --taxa 163 \
    --percent 0.$percent \
    --output mafft-nexus-internal-trimmed-gblocks-clean-${percent}p \
    --log-path log

# build the concatenated data matrix in phylip format
${phylucedict}phyluce_align_concatenate_alignments \
    --alignments mafft-nexus-internal-trimmed-gblocks-clean-${percent}p \
    --output mafft-nexus-internal-trimmed-gblocks-clean-${percent}p-raxml \
    --phylip \
    --log-path log

# build the concatenated data matrix in nexus format
${phylucedict}phyluce_align_concatenate_alignments \
    --alignments mafft-nexus-internal-trimmed-gblocks-clean-${percent}p \
    --output mafft-nexus-internal-trimmed-gblocks-clean-${percent}p-raxml \
    --nexus \
    --log-path log

in=${workdict}taxon-sets/all/mafft-nexus-internal-trimmed-gblocks-clean-${percent}p-raxml/mafft-nexus-internal-trimmed-gblocks-clean-${percent}p-raxml.phylip

### Here follows the user commands:
# Define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes

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

iqtree2 -s ${in} --prefix tree-${percent}p_b1000 -B 1000 -alrt 1000 -m MFP -T 40 --safe

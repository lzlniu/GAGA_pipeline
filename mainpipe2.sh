#!/bin/bash
#PBS -W group_list=ku_00039 -A ku_00039
#PBS -N mainpipe
#PBS -e mainpipe.err
#PBS -o mainpipe.log
#PBS -m n
#PBS -l nodes=1:ppn=40,mem=120gb,walltime=48:00:00

# Go to the directory from where the job was submitted (initial directory is $HOME)
#echo Working directory is $PBS_O_WORKDIR
#cd $PBS_O_WORKDIR

### Here follows the user commands:
# define number of processors
NPROCS=`wc -l < $PBS_NODEFILE`
echo This job has allocated $NPROCS nodes

#author:Zelin Li
#date:2021.09.25

workdict='/home/people/zelili/zhanglab/GAGA/'
phylucedict='/home/projects/ku_00039/people/zelili/programs/miniconda2/envs/phyluce-1.7.1/bin/'
probe='/home/people/zelili/zhanglab/GAGA/baits/hymenoptera-v2-ANT-SPECIFIC-uce-baits.fasta.txt'
probefile=`echo $probe | awk -F '/' '{print $NF}'`

#cd ${workdict}GAGA_all_final_assemblies
#for i in $(ls *.fasta.gz | sed -e 's/.fasta.gz//g'); do
        #((count=count + 1))
#        gunzip ${i}.fasta.gz
#done

cd $workdict

${phylucedict}phyluce_assembly_match_contigs_to_probes \
    --contigs ant-genome-fasta \
    --probes ${probe} \
    --output uce-search-results

mkdir -p taxon-sets/all

echo "[all]" > taxon-set.conf
for i in $(cat scaffoldlist.txt); do
	echo $i >> taxon-set.conf
done

# create the data matrix configuration file
${phylucedict}phyluce_assembly_get_match_counts \
    --locus-db ${workdict}uce-search-results/probe.matches.sqlite \
    --taxon-list-config ${workdict}taxon-set.conf \
    --taxon-group 'all' \
    --incomplete-matrix \
    --output taxon-sets/all/all-taxa-incomplete.conf

# change to the taxon-sets/all directory
cd ${workdict}taxon-sets/all

# make a log directory to hold our log files - this keeps things neat
mkdir log

# get FASTA data for taxa in our taxon set
${phylucedict}phyluce_assembly_get_fastas_from_match_counts \
    --contigs ${workdict}ant-genome-fasta \
    --locus-db ${workdict}uce-search-results/probe.matches.sqlite \
    --match-count-output all-taxa-incomplete.conf \
    --output all-taxa-incomplete.fasta \
    --incomplete-matrix all-taxa-incomplete.incomplete \
    --log-path log

# align the data
${phylucedict}phyluce_align_seqcap_align \
    --input all-taxa-incomplete.fasta \
    --output mafft-nexus-edge-trimmed \
    --taxa 163 \
    --aligner mafft \
    --incomplete-matrix \
    --log-path log

# align the data - turn off trimming and output FASTA
${phylucedict}phyluce_align_seqcap_align \
    --input all-taxa-incomplete.fasta \
    --output mafft-nexus-internal-trimmed \
    --taxa 163 \
    --aligner mafft \
    --incomplete-matrix \
    --output-format fasta \
    --no-trim \
    --log-path log

# run gblocks trimming on the alignments
${phylucedict}phyluce_align_get_gblocks_trimmed_alignments_from_untrimmed \
    --alignments mafft-nexus-internal-trimmed \
    --output mafft-nexus-internal-trimmed-gblocks \
    --log log

${phylucedict}phyluce_align_get_align_summary_data \
    --alignments mafft-nexus-internal-trimmed-gblocks \
    --log-path log

# align the data - turn off trimming and output FASTA
${phylucedict}phyluce_align_remove_locus_name_from_files \
    --alignments mafft-nexus-internal-trimmed-gblocks \
    --output mafft-nexus-internal-trimmed-gblocks-clean \
    --log-path log

# the integer following --taxa is the number of TOTAL taxa
# and I use "75p" to denote the 75% complete matrix
${phylucedict}phyluce_align_get_only_loci_with_min_taxa \
    --alignments mafft-nexus-internal-trimmed-gblocks-clean \
    --taxa 163 \
    --percent 0.75 \
    --output mafft-nexus-internal-trimmed-gblocks-clean-75p \
    --log-path log

# build the concatenated data matrix in phylip format
${phylucedict}phyluce_align_concatenate_alignments \
    --alignments mafft-nexus-internal-trimmed-gblocks-clean-75p \
    --output mafft-nexus-internal-trimmed-gblocks-clean-75p-raxml \
    --phylip \
    --log-path log

# build the concatenated data matrix in nexus format
${phylucedict}phyluce_align_concatenate_alignments \
    --alignments mafft-nexus-internal-trimmed-gblocks-clean-75p \
    --output mafft-nexus-internal-trimmed-gblocks-clean-75p-raxml \
    --nexus \
    --log-path log

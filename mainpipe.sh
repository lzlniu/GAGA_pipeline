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
#date:2021.09.24

workdict='/home/people/zelili/zhanglab/GAGA/'
phylucedict='/home/projects/ku_00039/people/zelili/programs/miniconda2/envs/phyluce-1.7.1/bin/'
probe='/home/people/zelili/zhanglab/GAGA/baits/hymenoptera-v2-ANT-SPECIFIC-uce-baits.fasta.txt'
probefile=`echo $probe | awk -F '/' '{print $NF}'`

#cd ${workdict}GAGA_all_final_assemblies
#echo "[scaffolds]" > ${workdict}genomes.conf

#count=0
#for i in $(ls *.fasta.gz | sed -e 's/.fasta.gz//g'); do
	#((count=count + 1))
	#gunzip ${i}.fasta.gz #remove this line then is fasta to 2bit (also change for '.fasta.gz' above), adding this then is gz to 2bit
	#mkdir ${workdict}ant${count}
	#${phylucedict}faToTwoBit ${workdict}GAGA_all_final_assemblies/${i}.fasta ${workdict}ant${count}/ant${count}.2bit
	#${phylucedict}twoBitInfo ${workdict}ant${count}/ant${count}.2bit ${workdict}ant${count}/${i}_sizes.tab
	#echo ${i} >> scaffoldnamelist.txt
	#echo ant${count} >> ${workdict}scaffoldlist.txt
	#echo "ant${count}:${workdict}/ant${count}/ant${count}.2bit" >> ${workdict}genomes.conf
#done

#cd $workdict
#${phylucedict}phyluce_probe_run_multiple_lastzs_sqlite \
#        --db ant.sqlite \
#        --output ant-genome-lastz \
#        --scaffoldlist `cat scaffoldlist.txt` \
#        --genome-base-path $workdict \
#        --probefile ${probe}

#${phylucedict}phyluce_probe_slice_sequence_from_genomes \
#        --lastz ant-genome-lastz \
#        --conf genomes.conf \
#        --name-pattern "${probefile}_v_{}.lastz.clean" \
#        --flank 500 \
#        --output ant-genome-fasta

cd ${workdict}GAGA_all_final_assemblies
for i in $(ls *.fasta | sed -e 's/.fasta//g'); do
echo "#!/bin/sh
#PBS -N gzip_
#PBS -e gzip_.err
#PBS -o gzip_.log
gzip -9 ${workdict}GAGA_all_final_assemblies/${i}.fasta
" > ${workdict}/gzip_.sh
cd $workdict
qsub < gzip_.sh
done

#rm -rf pipe_*.sh
#rm -rf ant*_genomes.conf

#rm -rf scaffoldlist.txt

#qsub ucesearch.sh
#bash fatogz.sh #or you can just change this to 'rm -rf *.fasta' below

#for i in $(ls *.2bit | sed -e 's/.2bit//g'); do
#	twoBitInfo ${i}.2bit ${i}_sizes.tab
#done

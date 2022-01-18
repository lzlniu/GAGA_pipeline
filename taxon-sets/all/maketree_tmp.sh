
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

echo Working directory is /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all
cd /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all

module load tools
module load ngs
module load anaconda3/4.4.0
module load perl
module load trimal/1.4.1
module load muscle/3.8.425
module load iqtree/2.1.2

echo modules loaded
#cp /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/mafft-nexus-internal-trimmed-gblocks-clean-95p-raxml/*.phylip /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/mafft-nexus-internal-trimmed-gblocks-clean-95p-raxml/topology.phylip
#echo phylip copied
#bash /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/tree_name.sh /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/mafft-nexus-internal-trimmed-gblocks-clean-95p-raxml/topology.phylip
#echo phylip ants name renamed
#iqtree2 -s /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/mafft-nexus-internal-trimmed-gblocks-clean-95p-raxml/topology.phylip --prefix astral_topo_ge82_95p -g /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/data/astral_out_ge82/cp_con_all_contree_BootstrapCollapsed.nwk -T 40 --safe
iqtree2 -s /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/mafft-nexus-internal-trimmed-gblocks-clean-95p-raxml/topology.phylip --prefix astral_topo_ge82_95p -g /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/data/astral_out_ge82/cp_con_all_contree_BootstrapCollapsed.nwk -B 1000 -m MFP -T 40 --safe
#rm -rf /home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/mafft-nexus-internal-trimmed-gblocks-clean-95p-raxml/topology.phylip
#echo phylip removed


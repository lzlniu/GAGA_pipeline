#!/bin/bash

# Load all required modules for the job
#module load tools
#module load ngs
#module load anaconda3/4.4.0
#module load perl
#module load trimal/1.4.1
#module load muscle/3.8.425
#module load iqtree/2.1.2

# This is where the work is done
# Make sure that this script is not bigger than 64kb ~ 150 lines, otherwise put in seperat script and execute from here

uce_dict="/home/projects/ku_00039/people/zelili/GAGA/taxon-sets/all/exploded-uces-fastas"
cd $uce_dict
for uce in $(ls aln_oneline_uce-* | sed -e 's/aln_oneline_//g' | sed -e 's/.fasta//g'); do
	echo -e "#!/bin/bash\n#PBS -N ${uce}\n#PBS -l walltime=240:00:00\n#PBS -e each_uce_tree_err.log\n#PBS -o each_uce_tree_out.log\nmodule load tools\nmodule load ngs\nmodule load anaconda3/4.4.0\nmodule load perl\nmodule load trimal/1.4.1\nmodule load muscle/3.8.425\nmodule load iqtree/2.1.2\ncd ${uce_dict}\niqtree2 -s ${uce_dict}/aln_oneline_${uce}.fasta --prefix tree_${uce} -B 1000 -m MFP -T 1 --safe" > $uce_dict/each_uce_tree.sh
	qsub $uce_dict/each_uce_tree.sh
done

# iqtree -alrt is SH-aLRT bootstrap method, while -B is ultrafast bootstrap method; for astral (gene-tree species tree method) it's recommand only use one of them, here is -B


#!/bin/bash
#author:Zelin Li

module load tools
module load newick-utils/1.6

echo "In >16 >41 >82 >122 >147"
for num in 16 41_old 82 122 147; do
sum=0
for i in $(nw_display data/astral_out_ge${num}/cp_con_all_contree_BootstrapCollapsed.nwk | grep -o "0\..."); do
	a=`echo $i | bc -l`
	s=$(awk -v flo=$a 'BEGIN{print flo*100}')
	((sum=sum+s))
	#echo $i $s $sum
done
line=`nw_display data/astral_out_ge${num}/cp_con_all_contree_BootstrapCollapsed.nwk | grep -o "0\..." | wc -l`
echo $num $line $sum
echo $sum/$line | bc
done

echo "In >41, bootstrap collaspe 10 20 30 40 50"
#cp_con_all_contree_bc20.nwk
for num in 10 20 30 40 50; do
sum=0
for i in $(nw_display data/astral_out_ge41/cp_con_all_contree_bc${num}.nwk | grep -o "0\..."); do
	a=`echo $i | bc -l`
	s=$(awk -v flo=$a 'BEGIN{print flo*100}')
	((sum=sum+s))
	#echo $i $s $sum
done
line=`nw_display data/astral_out_ge41/cp_con_all_contree_bc${num}.nwk | grep -o "0\..." | wc -l`
echo $num $line $sum
echo $sum/$line | bc
done

echo "In 3 concacenate matrix trees"
for percent in 75 90 95; do
sum=0
for i in $(nw_display tree-${percent}p_b1000.contree | grep -o "0\..."); do
	a=`echo $i | bc -l`
	s=$(awk -v flo=$a 'BEGIN{print flo*100}')
	((sum=sum+s))
	#echo $i $s $sum
done
line=`nw_display tree-${percent}p_b1000.contree | grep -o "0\..." | wc -l`
echo $percent $line $sum
echo $sum/$line | bc
done

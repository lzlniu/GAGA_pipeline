#!/bin/bash

workdict='/home/projects/ku_00039/people/zelili/GAGA'
input=$1

cd $workdict
for i in $(ls ant*/*.tab | sed -e 's/_filt_sizes.tab//g' | awk -F 'ant' '{print $2}' | sort -t '/' -k 1rn | awk '{print"ant" $0}' | awk -F '_' '{print $1}'); do
	antnum=`echo $i | awk -F '/' '{print $1}'`
	antname=`echo $i | awk -F '/' '{print $2}'`
	#echo $antnum
	#echo $antname
	sed -i "s/${antnum}/${antname}/g" $input
done

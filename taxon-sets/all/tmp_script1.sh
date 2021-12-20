#!/bin/bash
for i in $(cat diff/*); do
	printf "$i:\n"
	cat exploded-uces-fastas/${i}.log
	printf "\n"
done

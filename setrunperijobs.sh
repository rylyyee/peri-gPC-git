#!/bin/bash

# What should you space the jobs by?
countby=3
endrun=15
howmany=$((endrun/countby))

for i in `seq 1 $howmany`;
do

second=$((countby*i))
first=$((second-(countby-1)))
echo Print $first to $second runs. 

awk -v var="$first" 'NR==8 {$0="startrun="'"var"'""} 1' runperi.job > temp${i}
awk -v var="$second" 'NR==9 {$0="endrun="'"var"'""} 1' temp${i} > go${first}to${second}.job

rm temp${i}

#sbatch go${first}to${second}.job

done

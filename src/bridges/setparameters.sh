#!/bin/bash

WD=${1:?Provide a working directory}
a=${2:?Provide a simulation set number}

# Separate main parameter file into three files
cut -f 2 "$WD"/data/parameters/allpara_${a}.txt > pamp.txt
cut -f 3 "$WD"/data/parameters/allpara_${a}.txt > Freq.txt

# Count number of lines in files
numlines=$(grep -c "^" "$WD"/data/parameters/allpara_${a}.txt)

# initialize variables
pam=0
Freq=0
# For loop that will write files
for i in `seq 1 $numlines`;
do
# Sets Wo based on i
pamp=$(awk -v var="$i" 'NR==var' pamp.txt)
# Writes file to replace line with Wo
cat template-parameters |  awk -v var="$pamp" 'NR==6 {$0="pamp = "'"var"'"  \\ "} 1' template-parameters > parametersw${i}
# Sets Freq based on i
Freq=$(awk -v var="$i" 'NR==var' Freq.txt)
# Writes file to replace line with Freq
cat template-parameters |  awk -v var="$Freq" 'NR==7 {$0="freq = "'"var"'"   \\"} 1' parametersw${i} > parametersw${i}f${i}
cat template-parameters |  awk -v var="$Freq" 'NR==8 {$0="iposn = "'"var"'"   \\"} 1' parametersw${i}f${i} > parametersw${i}f${i}l${i}
# Cleans up folder
rm parametersw${i} parametersw${i}f${i}
mv parametersw${i}f${i}l${i} "$WD"/data/parameters-files/parameters${i}
done

rm pamp.txt 
mv Freq.txt "$WD"/data/parameters/

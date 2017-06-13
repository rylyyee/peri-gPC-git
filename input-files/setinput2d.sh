#!/bin/bash

# Separate main parameter file into three files
cut -f 1 allpara.txt > Wo.txt
cut -f 2 allpara.txt > pamp.txt
cut -f 3 allpara.txt > Freq.txt

# Count number of lines in files
numlines=$(grep -c "^" allpara.txt)

# initialize variables
WO=10
Freq=10
# For loop that will write files
for i in `seq 1 $numlines`;
do
# Sets Wo based on i
WO=$(awk -v var="$i" 'NR==var' Wo.txt)
# Writes file to replace line with Wo
cat input2d |  awk -v var="$WO" 'NR==7 {$0="WO = "'"var"'"   // Womersley number"} 1' input2d > input2dw${i}
# Sets Freq based on i
Freq=$(awk -v var="$i" 'NR==var' pamp.txt)
# Writes file to replace line with Freq
cat input2d |  awk -v var="$WO" 'NR==5 {$0="FRE = "'"var"'"   // Pumping Frequency (Hz)"} 1' input2dw${i} > input2dw${i}f${i}
# Cleans up folder
rm input2dw${i}
mv input2dw${i}f${i} input2d${i}
done
# above works


cat input2d |  awk -v var="$variable" 'NR==7 {$0="WO = var   // Womersley number"} 1' input2d > input2d2  # This will replace a single line in input2d and copy it to input2d

cat input2d |  awk 'BEGIN {} { for(i=1; i <=5; i++)  NR==7 $0="WO = $i   // Womersley number" 1}' input2d > input2d2

awk 'BEGIN { print "START" } { for(i=1; i <=NR; i++) print i} END { print NR }' input2d


#!/bin/bash

WD=${1:?Provide a working directory}
a=${2:?Provide a simulation set number}

# Separate main parameter file into three files
cut -f 1 "$WD"/data/parameters/allpara_${a}.txt > Wo.txt
# cut -f 2 allpara.txt > pamp.txt
cut -f 3 "$WD"/data/parameters/allpara_${a}.txt > Freq.txt

# Count number of lines in files
numlines=$(grep -c "^" "$WD"/data/parameters/allpara_${a}.txt)

# initialize variables
WO=0
Freq=0
# For loop that will write files
for i in `seq 1 $numlines`;
do
# Sets Wo based on i
WO=$(awk -v var="$i" 'NR==var' Wo.txt)
# Writes file to replace line with Wo
awk -v var="$WO" 'NR==7 {$0="WO = "'"var"'"   // Womersley number"} 1' template-input2d > input2dw${i}
# Sets Freq based on i
Freq=$(awk -v var="$i" 'NR==var' Freq.txt)
# Writes file to replace line with Freq
awk -v var="$Freq" 'NR==5 {$0="FRE = "'"var"'"   // Pumping Frequency (Hz)"} 1' input2dw${i} > input2dw${i}f${i}
# Edits input2d to create different IBlog and visit files and folders
awk -v var="$i" 'NR==230 {$0="   log_file_name = \"../results/ibamr/log-files/IB2d.log"'"var"'"\"                //"} 1' input2dw${i}f${i} > input2dw${i}f${i}l${i}
awk -v var="$i" 'NR==236 {$0="   viz_dump_dirname = \"../results/ibamr/runs/viz_IB2d"'"var"'"\"                //"} 1' input2dw${i}f${i}l${i} > input2dw${i}f${i}l${i}y${i}
awk -v var="$i" 'NR==245 {$0="   data_dump_dirname = \"../results/ibamr/runs/hier_data_IB2d"'"var"'"\"          //"} 1' input2dw${i}f${i}l${i}y${i} > input2dw${i}f${i}l${i}y${i}j${i}
test=$Freq
echo $test
if [ $(echo " $test <= 0.70" | bc) -eq 1 ]
then 
    cat template-input2d |  awk 'NR==25 {$0="END_TIME =      3.5                // Final Simulation Time (s)"} 1' input2dw${i}f${i}l${i}y${i}j${i} > input2dw${i}f${i}l${i}y${i}j${i}t${i}
elif [ $(echo " $test < 1.0" | bc) -eq 1 ]
then
    cat template-input2d |  awk 'NR==25 {$0="END_TIME =       3.0               // Final Simluation Time (s)"} 1' input2dw${i}f${i}l${i}y${i}j${i} > input2dw${i}f${i}l${i}y${i}j${i}t${i}
else
    cat template-input2d |  awk 'NR==25 {$0="END_TIME =       2.5                // Final Simulation Time (s)"} 1' input2dw${i}f${i}l${i}y${i}j${i} > input2dw${i}f${i}l${i}y${i}j${i}t${i}
fi

# Cleans up folder
rm input2dw${i} input2dw${i}f${i} input2dw${i}f${i}l${i} input2dw${i}f${i}l${i}y${i} input2dw${i}f${i}l${i}y${i}j${i}
mv input2dw${i}f${i}l${i}y${i}j${i}t${i} "$WD"/data/input2d-files/input2d${i}

echo $i
#grep "END_TIME =" input2d${i}  && grep "FRE ="  input2d${i}

done

rm Freq.txt Wo.txt

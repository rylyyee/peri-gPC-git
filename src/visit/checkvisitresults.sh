#!/bin/bash

WD=${1:?Provide a top-level directory path}
track=${2:?Please provide a circulatory system name}
b=${3:?Provide the number of simulations to check}

cd "${WD}"/results/visit/${track}_runs/

echo "Individual files:"
for i in `seq 1 $b`; do 
  if [ ! -f sim${i}/aorta_P_avg.curve ]; then
      echo "Sim ${i}: aorta P avg is missing"
  fi
  if [ ! -f sim${i}/aorta_P_max.curve ]; then
      echo "Sim ${i}: aorta P max is missing"
  fi
  if [ ! -f sim${i}/aorta_Um_avg.curve ]; then
      echo "Sim ${i}: aorta Um avg missing"
  fi
  if [ ! -f sim${i}/aorta_Um_max.curve ]; then
      echo "Sim ${i}: aorta Um max missing"
  fi
  if [ ! -f sim${i}/aorta_Ux_avg.curve ]; then
      echo "Sim ${i}: aorta Ux avg missing"
  fi
  if [ ! -f sim${i}/aorta_Ux_max.curve ]; then
      echo "Sim ${i}: aorta Ux max missing"
  fi
  if [ ! -f sim${i}/aorta_Um_avg.curve ]; then
      echo "Sim ${i}: aorta Um avg missing"
  fi
  if [ ! -f sim${i}/connect_Um_avg.curve ]; then
      echo "Sim ${i}: connect Um avg missing"
  fi
  if [ ! -f sim${i}/connect_Um_max.curve ]; then
      echo "Sim ${i}: connect Um max missing"
  fi
  if [ ! -f sim${i}/connect_Uy_avg.curve ]; then
      echo "Sim ${i}: connect Uy avg missing"
  fi
  if [ ! -f sim${i}/connect_Uy_max.curve ]; then
      echo "Sim ${i}: connect Uy max missing"
  fi
  if [ ! -f sim${i}/vena_Um_avg.curve ]; then
      echo "Sim ${i}: vena Um avg missing"
  fi
  if [ ! -f sim${i}/vena_Um_max.curve ]; then
      echo "Sim ${i}: vena Um max missing"
  fi
  if [ ! -f sim${i}/vena_Ux_avg.curve ]; then
      echo "Sim ${i}: vena Ux avg missing"
  fi
  if [ ! -f sim${i}/vena_Um_max.curve ]; then
      echo "Sim ${i}: vena Um max missing"
  fi
  if [ ! -f sim${i}/vena_P_avg.curve ]; then
      echo "Sim ${i}: vena P avg missing"
  fi
  if [ ! -f sim${i}/vena_P_max.curve ]; then
      echo "Sim ${i}: vena P max missing"
  fi
done
echo " "

cut -f 3 "$WD"/data/parameters/allpara_${b}.txt > Freq.txt

echo "Time series files: "
for i in `seq 1 $b`; do 
  Freq=$(awk -v var="$i" 'NR==var' "Freq.txt")
  
  if [ $(echo " $Freq <= 0.70" | bc) -eq 1 ]; then
    if [ ! -f sim${i}/Um_profile0035.curve ]; then
      echo "Sim ${i}: end file not found" 
    fi
  elif [ $(echo " $Freq < 1.0" | bc) -eq 1 ]; then
    if [ ! -f sim${i}/Um_profile0030.curve ]; then
      echo "Sim ${i}: end file not found" 
    fi
  else
    if [ ! -f sim${i}/Um_profile0025.curve ]; then
      echo "Sim ${i}: end file not found" 
    fi
  fi
done

rm Freq.txt
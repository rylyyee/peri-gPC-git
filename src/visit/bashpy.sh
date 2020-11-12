#!/bin/bash

WD=${1:?Please provide a top-level working directory}
track=${2:?Please provide a circulatory system name}
startrun=${3:?Provide a start run number}
endrun=${4:?Provide an end run number}

for i in `seq ${startrun} ${endrun}`; do
  if [ -d "$WD"/results/visit/${track}_runs/sim${i}/ ]; then
    rm "$WD"/results/visit/${track}_runs/sim${i}/*.curve
  else
    mkdir -p "$WD"/results/visit/${track}_runs/sim${i}/
  fi
done


# Script for running several VisIt python scripts

# Check to see if all files are present first!! 

/Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s profile_connect_Um.py \
"$WD"/results/ibamr/${track}_runs "$WD"/results/visit/${track}_runs $startrun $(($endrun+1))

/Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s aorta_P.py \
"$WD"/results/ibamr/${track}_runs "$WD"/results/visit/${track}_runs $startrun $(($endrun+1))

/Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s aorta_Um.py \
"$WD"/results/ibamr/${track}_runs "$WD"/results/visit/${track}_runs $startrun $(($endrun+1))

/Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s aorta_Ux.py \
"$WD"/results/ibamr/${track}_runs "$WD"/results/visit/${track}_runs $startrun $(($endrun+1))

/Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s connect_Um.py \
"$WD"/results/ibamr/${track}_runs "$WD"/results/visit/${track}_runs $startrun $(($endrun+1))

/Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s connect_Uy.py \
"$WD"/results/ibamr/${track}_runs "$WD"/results/visit/${track}_runs $startrun $(($endrun+1))

/Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s vena_P.py \
"$WD"/results/ibamr/${track}_runs "$WD"/results/visit/${track}_runs $startrun $(($endrun+1))

/Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s vena_Um.py \
"$WD"/results/ibamr/${track}_runs "$WD"/results/visit/${track}_runs $startrun $(($endrun+1))

/Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s vena_Ux.py \
"$WD"/results/ibamr/${track}_runs "$WD"/results/visit/${track}_runs $startrun $(($endrun+1))


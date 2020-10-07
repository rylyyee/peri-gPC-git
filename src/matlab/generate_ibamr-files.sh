#!/bin/bash

WD=${1:?Please provide a top directory}
track=${2:?Please provide a circulatory track}

rm "$WD"/data/ibamr-files/${track}/*
rm "$WD"/bin/*.vertex "$WD"/bin/*.target "$WD"/bin/*.beam "$WD"/bin/*.spring

module load matlab

matlab -r "generate_${track};exit"

cp *.vertex *.target *.beam *.spring "$WD"/bin
mv *.vertex *.target *.beam *.spring "$WD"/data/ibamr-files/${track}/ 

module unload matlab

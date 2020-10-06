#!/bin/bash

#Shell script for compiling the main2d program in IBAMR. To be run on Bridges.
WD=${1:?Please provide a path for the main directory}

cd "$WD"
echo "Setting up directories..."
mkdir bin/
mkdir results/
mkdir results/ibamr
mkdir results/ibamr/runs/
mkdir results/ibamr/log-files/
mkdir results/visit/
mkdir results/visit/racetrack/
mkdir results/visit/branch/
mkdir results/visit/obstacles/
mkdir results/visit/branchandobstacles/
mkdir results/r-csv-files/
mkdir results/r-csv-files/racetrack/
mkdir results/r-csv-files/branch/
mkdir results/r-csv-files/obstacles/
mkdir results/r-csv-files/branchandobstacles/
mkdir data/
mkdir data/vertex-files/
mkdir data/vertex-files/racetrack/
mkdir data/vertex-files/branch/
mkdir data/vertex-files/obstacles/
mkdir data/vertex-files/branchandobstacles/
mkdir data/csv-files/
mkdir data/csv-files/racetrack/
mkdir data/csv-files/branch/
mkdir data/csv-files/obstacles/
mkdir data/csv-files/branchandobstacles/
mkdir data/input2d-files/

cd "$WD"/src/ibamr
echo "Compiling main2d..."
make main2d
mv main2d "$WD"/bin
rm *.o stamp-2d

cd "$WD"/src/bridges/
echo "Complete"

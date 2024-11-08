#!/bin/bash
#SBATCH --nodes=1                # number of node MUST be 1
#SBATCH --ntasks-per-node=40
#SBATCH --time=1:00:00           # time (DD-HH:MM)
#SBATCH --output=simjob.txt
#SBATCH --mail-type=FAIL         # send an email if job aborted

module load intel/2019u4 gcc/8.3.0 r/4.1.2

N=50
B=100
S=100

R CMD BATCH "--args N=$N B=$B S=$S" simscript_example.R
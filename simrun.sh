#!/bin/bash
#SBATCH --nodes=1                # number of node MUST be 1
#SBATCH --ntasks-per-node=40
#SBATCH --cpus-per-task=4        # number of processes
#SBATCH --time=1:00:00           # time (DD-HH:MM)
#SBATCH --output=simjob.txt
#SBATCH --mail-type=FAIL         # send an email if job aborted

module load gcc/9.3.0 r/4.1.2

N=50
B=100
S=100

R CMD BATCH "--args N=$N B=$B S=$S" simscript_example.R
#!/bin/bash -l
#SBATCH -N 10                # Number of nodes
#SBATCH -J stills_proc
#SBATCH -L SCRATCH          # job requires SCRATCH files
#SBATCH -A lcls_g          # allocation
#SBATCH -C gpu
#SBATCH -q regular    # regular queue
#SBATCH -t 00:10:00         # wall clock time limit
#SBATCH -o job%j.out
#SBATCH -e job%j.err

export WORK=$SCRATCH/psii_sim
cd $WORK

mkdir $SLURM_JOB_ID; cd $SLURM_JOB_ID
echo "jobstart $(date)";pwd

srun -n 320 -c 4 dials.stills_process $MODULES/SPREAD/index1.phil input.glob=$SCRATCH/psii_sim/8672390/image_rank_*.h5

echo "jobend $(date)";pwd
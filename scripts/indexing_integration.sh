#!/bin/bash -l
#SBATCH -N 10                # Number of nodes
#SBATCH -J stills_proc
#SBATCH -L SCRATCH          # job requires SCRATCH files
#SBATCH -A lcls_g          # allocation
#SBATCH -C gpu
#SBATCH -q regular    # regular queue
#SBATCH -t 01:00:00         # wall clock time limit
#SBATCH -o job%j.out
#SBATCH -e job%j.err

export WORK=$SCRATCH/psii_sim
cd $WORK

mkdir -p dials_processing; cd dials_processing
echo "jobstart $(date)";pwd

srun -n 320 -c 4 dials.stills_process $MODULES/SPREAD/scripts/indexing_integration.phil input.glob=$SCRATCH/psii_sim/images_0/image_rank_*.h5

echo "jobend $(date)";pwd
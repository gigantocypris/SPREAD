#!/bin/bash
#SBATCH --nodes 10
#SBATCH -C gpu
#SBATCH -q regular    # regular queue
#SBATCH -t 00:10:00         # wall clock time limit
#SBATCH --job-name=${1}
#SBATCH -A m2859_g          # allocation


RUN_NUM=${1} #0080
echo $RUN_NUM
OUTPUT_DIR=/global/cfs/cdirs/m3562/users/vidyagan/p20231/common/results/processed_may_10_2023/r${1}


mkdir -p $OUTPUT_DIR
mkdir -p $OUTPUT_DIR/stdout
srun -n 320 -c 2 dials.stills_process $MODULES/SPREAD/params_1.phil \
output.output_dir=$OUTPUT_DIR \
output.logging_dir=$OUTPUT_DIR/stdout  \
input.glob=/global/cfs/cdirs/m3562/sf_bernina_data_p20231/assembled/$RUN_NUM/*.h5 \
mp.method=mpi dispatch.pre_import=True

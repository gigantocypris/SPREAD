#!/bin/bash
#SBATCH --nodes 10
#SBATCH -C gpu
#SBATCH -q regular    # regular queue
#SBATCH -t 00:15:00         # wall clock time limit
#SBATCH --job-name=step1
#SBATCH -A m2859_g          # allocation


RUN_NUM=${1} #080
echo $RUN_NUM
OUTPUT_DIR=/global/cfs/cdirs/m3562/users/vidyagan/p20231/common/results/processed_may_10_2023/r${1}


mkdir -p $OUTPUT_DIR
mkdir -p $OUTPUT_DIR/stdout
srun -n 320 -c 2 dials.stills_process \
output.output_dir=$OUTPUT_DIR \
output.logging_dir=$OUTPUT_DIR/stdout \
/global/cfs/cdirs/m3562/sf_bernina_data_p20231/assembled/$RUN_NUM/*.h5 \
$MODULES/SPREAD/${2} \
mp.method=mpi dispatch.pre_import=True

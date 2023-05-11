# salloc -N 1 --time=60 -C gpu -A m3562_g --qos=interactive --ntasks-per-gpu=8 --cpus-per-task=2

RUN_NUM=211
PHIL_FILE=params_1.phil
echo $RUN_NUM
OUTPUT_DIR=/global/cfs/cdirs/m3562/users/vidyagan/p20231/common/results/processed_may_10_2023/interactive_r$RUN_NUM


mkdir -p $OUTPUT_DIR
mkdir -p $OUTPUT_DIR/stdout
cctbx.xfel.process \
output.output_dir=$OUTPUT_DIR \
output.logging_dir=$OUTPUT_DIR/stdout \
/global/cfs/cdirs/m3562/sf_bernina_data_p20231/assembled/$RUN_NUM/*.h5 \
$MODULES/SPREAD/$PHIL_FILE \
mp.method=mpi dispatch.pre_import=True
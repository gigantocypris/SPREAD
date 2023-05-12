# salloc -N 1 --time=60 -C gpu -A m3562_g --qos=interactive --ntasks-per-gpu=8 --cpus-per-task=2

export SCRATCH_FOLDER=$SCRATCH/psii_sim/interactive
mkdir -p $SCRATCH_FOLDER; cd $SCRATCH_FOLDER

export MN_RESOLUTION=10
export MN_CHANNELS=20

export CCTBX_DEVICE_PER_NODE=1
export N_START=0
export LOG_BY_RANK=1 # Use Aaron's rank logger
export RANK_PROFILE=0 # 0 or 1 Use cProfiler, default 1
export N_SIM=1 # total number of images to simulate
export ADD_BACKGROUND_ALGORITHM=cuda
export DEVICES_PER_NODE=1
export MOS_DOM=25

export CCTBX_NO_UUID=1
# export DIFFBRAGG_USE_CUDA=1
export DIFFBRAGG_USE_KOKKOS=1
export CUDA_LAUNCH_BLOCKING=1
export NUMEXPR_MAX_THREADS=128
export SLURM_CPU_BIND=cores # critical to force ranks onto different cores. verify with ps -o psr <pid>
export OMP_PROC_BIND=spread
export OMP_PLACES=threads
export SIT_PSDM_DATA=/global/cfs/cdirs/lcls/psdm-sauter
export CCTBX_GPUS_PER_NODE=1
export XFEL_CUSTOM_WORKER_PATH=$MODULES/psii_spread/merging/application # User must export $MODULES path

echo "
noise=True
psf=False
attenuation=True
context=kokkos_gpu
crystal.structure=PSII
beam {
  mean_wavelength=6550.
}
detector {
  tiles=multipanel
  reference=$MODULES/exafel_project/kpp-sim/t000_rg002_chunk000_reintegrated_000000.expt
}
output {
  format=h5
}
" > trial.phil

echo "jobstart $(date)";pwd
libtbx.python $MODULES/exafel_project/kpp_utils/LY99_batch.py trial.phil
echo "jobend $(date)";pwd

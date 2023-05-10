#!/bin/bash -l
#SBATCH -N 16
#SBATCH --job-name=PSII_all_merge
#SBATCH --time=30
#SBATCH -A m2859_g
#SBATCH -C cpu
#SBATCH --qos=realtime
#SBATCH -o job%j.out
#SBATCH -e job%j.err
mkdir -p $SLURM_JOB_ID; cd $SLURM_JOB_ID
export CCTBX_NO_UUID=1
export DIFFBRAGG_USE_CUDA=1
export CUDA_LAUNCH_BLOCKING=1
export NUMEXPR_MAX_THREADS=128
export SLURM_CPU_BIND=cores # critical to force ranks onto different cores. verify with ps -o psr <pid>
export OMP_PROC_BIND=spread
export OMP_PLACES=threads
export SIT_PSDM_DATA=/pscratch/sd/p/psdatmgr/data/pmscr
export CCTBX_GPUS_PER_NODE=1
export MPI4PY_RC_RECV_MPROBE='False' # compensates for current missing MPI functions

echo "jobstart $(date)";pwd
srun -n 1024 cctbx.xfel.merge $MODULES/SPREAD/merging.phil
echo "jobend $(date)";pwd


# scaling and merging parameters that were input into the GUI

dispatch.step_list=input balance model_scaling modify filter errors_premerge scale postrefine statistics_unitcell statistics_beam model_statistics statistics_resolution
input.parallel_file_load.method=uniform
filter.outlier.min_corr=-1
filter.algorithm=unit_cell
filter.unit_cell.value.relative_length_tolerance=0.01
select.algorithm=significance_filter
select.significance_filter.sigma=0.5
select.significance_filter.min_ct=200
select.significance_filter.max_ct=300
scaling.model=/global/cfs/cdirs/m3562/references/5tis.pdb
scaling.resolution_scalar=0.96
merging.d_min=2.0
merging.merge_anomalous=True
postrefinement.enable=True
statistics.n_bins=20
output.do_timing=True
output.save_experiments_and_reflections=True

dispatch.step_list=input model_scaling statistics_unitcell statistics_beam model_statistics statistics_resolution group errors_merge statistics_intensity merge statistics_intensity_cxi
input.parallel_file_load.method=uniform
scaling.model=/global/cfs/cdirs/m3562/references/5tis.pdb
scaling.resolution_scalar=0.96
statistics.n_bins=20
merging.d_min=2.0
merging.merge_anomalous=True
merging.error.model=ev11
output.do_timing=True

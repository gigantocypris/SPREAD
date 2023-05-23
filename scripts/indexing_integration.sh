#!/bin/bash -l
#SBATCH -N 8                # Number of nodes
#SBATCH -J stills_proc
#SBATCH -L SCRATCH          # job requires SCRATCH files
#SBATCH -C cpu
#SBATCH -q regular    # regular queue
#SBATCH -t 01:30:00         # wall clock time limit
#SBATCH -o job%j.out
#SBATCH -e job%j.err

export NUMEXPR_MAX_THREADS=128
export SLURM_CPU_BIND=cores # critical to force ranks onto different cores. verify with ps -o psr <pid>
export OMP_PROC_BIND=spread
export OMP_PLACES=threads
export XFEL_CUSTOM_WORKER_PATH=$MODULES/psii_spread/merging/application # User must export $MODULES path

export IMAGE_PATH=$SCRATCH/psii_sim/images/image_rank_*.h5
export OUTPUT_FOLDER=dials_processing
export WORK=$SCRATCH/psii_sim
cd $WORK

mkdir -p $OUTPUT_FOLDER; cd $OUTPUT_FOLDER

echo "
output {
  composite_output = False
  logging_dir=. # demangle by rank
}
input {
  reference_geometry = $MODULES/exafel_project/kpp-sim/t000_rg002_chunk000_reintegrated_000000.expt
}
dispatch {
  index=True
  refine=True
  integrate=True
} 

mp {
  method = mpi
}
spotfinder {
  lookup {
    mask = None
  }
  filter {
    min_spot_size = 3
  }
  threshold {
    dispersion {
      gain = 1.0 # for nanoBragg sim
      sigma_background=2
      sigma_strong=2
      global_threshold=10
      kernel_size=6 6
    }
  }
  filter.min_spot_size=3
  filter.d_min=3.4
}
indexing {
  stills.refine_candidates_with_known_symmetry=True
  known_symmetry {
    space_group = "P 21 21 21"
    unit_cell = 117.585 223.068 309.977 90 90 90
  }
  refinement_protocol {
    d_min_start = 3.4
  }
}
integration {
  background.simple.outlier.plane.n_sigma=10
  debug.output=True
  debug.separate_files=False
  debug.delete_shoeboxes = False
  lookup {
  }
  summation {
    detector_gain = 1.0 # for nanoBragg sim
  }
}
profile.gaussian_rs.centroid_definition=com
" > trial.phil


echo "jobstart $(date)";pwd

srun -n 256 -c 8 dials.stills_process trial.phil input.glob=$IMAGE_PATH

echo "jobend $(date)";pwd
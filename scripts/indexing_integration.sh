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

export IMAGE_PATH=$SCRATCH/psii_sim/9287749/image_rank_*.h5
export OUTPUT_FOLDER=dials_processing_test
# export IMAGE_PATH=$SCRATCH/psii_sim/images/image_rank_*.h5
# export OUTPUT_FOLDER=dials_processing
export WORK=$SCRATCH/psii_sim
cd $WORK

mkdir -p $OUTPUT_FOLDER; cd $OUTPUT_FOLDER

echo "
input {
  reference_geometry = $MODULES/exafel_project/kpp-sim/t000_rg002_chunk000_reintegrated_000000.expt
}
dispatch {
  pre_import = True
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
  filter.d_min=1.9
}
indexing {
  stills.refine_candidates_with_known_symmetry=True
  known_symmetry {
    space_group = "P 21 21 21"
    unit_cell = 117.585 223.068 309.977 90 90 90
  }
  refinement_protocol {
    d_min_start = 3.0
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
mp.method = mpi
output.logging_dir=. # demangle by rank
" > trial.phil


echo "jobstart $(date)";pwd

srun -n 320 -c 4 dials.stills_process $MODULES/SPREAD/scripts/indexing_integration.phil input.glob=$IMAGE_PATH

echo "jobend $(date)";pwd
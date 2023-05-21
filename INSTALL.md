# Installation Instructions

Installation instructions are given for [Perlmutter](https://docs.nersc.gov/systems/perlmutter/architecture/). Please see the [homepage](README.md) for instructions on how to obtain a computing account.

Open a terminal on Perlmutter and set the following environment variables:
```
export NERSC_USERNAME=your_username
export NERSC_GPU_ALLOCATION=your_nersc_allocation
export CFS_ALLOCATION=your_cfs_allocation
```

Create directories:
```
export CFSW=$CFS/$CFS_ALLOCATION/users/$NERSC_USERNAME
mkdir $CFSW
export CFSSRC=$CFSW/p20231 
mkdir $CFSSRC
cd $CFSSRC
```

Start an interactive session on NERSC:
```
salloc -N 1 --time=120 -C gpu -A $NERSC_GPU_ALLOCATION --qos=interactive --ntasks-per-gpu=1
module purge
module load PrgEnv-gnu cpe-cuda cudatoolkit
```

Clone a repository containing installation scripts and run setup script:
```
git clone https://github.com/JBlaschke/alcc-recipes.git alcc-recipes
cd alcc-recipes/cctbx
./setup_perlmutter.sh 
```
Ignore returned errors.

Build `cctbx`:
```
cd $CFSSRC/alcc-recipes/cctbx
rm opt/mamba/envs/psana_env/lib/libssh.so.4
module load evp-patch
source utilities.sh
source opt/site/nersc_perlmutter.sh

load-sysenv
activate

mk-cctbx cuda build
```

Test that `kokkos` runs without returning an error with the following:
```
libtbx.python
from simtbx import get_exascale
g = get_exascale("exascale_api","kokkos_gpu")
```

Create your source file:
```
vi ~/env_spread
```

Copy the following into the file:
```
export CFSW=$CFS/$CFS_ALLOCATION/users/nersc_username
export CFSSRC=$CFSW/p20231 # software install
export WORK=$CFSW/p20231/
cd $WORK/
module purge
module load PrgEnv-gnu cpe-cuda cudatoolkit
module load evp-patch # known issue workaround
source $CFSSRC/alcc-recipes/cctbx/utilities.sh
source $CFSSRC/alcc-recipes/cctbx/opt/site/nersc_perlmutter.sh
load-sysenv
activate
export MODULES=$CFSSRC/alcc-recipes/cctbx/modules
export BUILD=$CFSSRC/alcc-recipes/cctbx/build
```

Save and exit: 
```
:wq
```

Source your environment:
```
> source ~/env_spread
> cd $CFSSRC/alcc-recipes/cctbx
```

Create the file `activate.sh:`
```
> vi activate.sh
```

Copy the following into the file:
```
export ALCC_CCTBX_ROOT=/global/cfs/cdirs/$CFS_ALLOCATION/users/$NERSC_USERNAME/p20231/alcc-recipes/cctbx
source ${ALCC_CCTBX_ROOT}/utilities.sh
source ${ALCC_CCTBX_ROOT}/opt/site/nersc_perlmutter.sh
load-sysenv
activate

export OMP_PLACES=threads
export OMP_PROC_BIND=spread
export KOKKOS_DEVICES="OpenMP;Cuda"
export KOKKOS_ARCH="Ampere80"
export CUDA_LAUNCH_BLOCKING=1
export SIT_DATA=\${OVERWRITE_SIT_DATA:-\$NERSC_SIT_DATA}:\$SIT_DATA
export SIT_PSDM_DATA=\${OVERWRITE_SIT_PSDM_DATA:-\$NERSC_SIT_PSDM_DATA}
export MPI4PY_RC_RECV_MPROBE='False'
export SIT_ROOT=/reg/g/psdm
```

Save and exit: 
```
:wq
```

Rebuild `cctbx`:
```
. activate.sh
mk-cctbx cuda build
```

Test GPU usage:
```
libtbx.python "/global/cfs/cdirs/$CFS_ALLOCATION/users/$NERSC_USERNAME/p20231/alcc-recipes/cctbx/modules/cctbx_project/simtbx/gpu/tst_shoeboxes.py" context=kokkos_gpu
```

At the same time in another window logged into the interactive session run:
```
watch -n 0.1 nvidia-smi
```

Watch the GPU usage to check that it increases. 

Printout of the `tst_shoeboxes.py` should look like the following:
```
OK
The following parameters have been modified:

context = *kokkos_gpu cuda

Make a beam
Make a dxtbx detector
Make a randomly oriented xtal

# Use case 1 (kokkos_gpu). Monochromatic source

assume monochromatic
USE_EXASCALE_API+++++++++++++ Wavelength 0=1.377602, Flux 1.000000e+11, Fluence 1.000000e+19

# Use case 2 (kokkos_gpu). Pixel masks.
3532 2355764 2359296

assume monochromatic
USE_WHITELIST(bool)_API+++++++++++++ Wavelength 0=1.377602, Flux 1.000000e+11, Fluence 1.000000e+19
USE_WHITELIST(bool)_API+++++++++++++ Wavelength 0=1.377602, Flux 1.000000e+11, Fluence 1.000000e+19
USE_WHITELIST(pixel_address)_API+++++++++++++ Wavelength 0=1.377602, Flux 1.000000e+11, Fluence 1.000000e+19
USE_WHITELIST(pixel_address)_API+++++++++++++ Wavelength 0=1.377602, Flux 1.000000e+11, Fluence 1.000000e+19
OK
```

Install the required modules:
```
cd $MODULES
conda install -c conda-forge nxmx
conda install -c conda-forge distro
conda install pytorch==1.13.1 torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia
git clone https://github.com/vganapati/LS49
git clone https://gitlab.com/cctbx/ls49_big_data
git clone https://gitlab.com/cctbx/uc_metrics
git clone https://github.com/lanl/lunus            
git clone https://github.com/dermen/sim_erice
git clone https://gitlab.com/cctbx/psii_spread.git    
git clone https://gitlab.com/cctbx/xfel_regression.git
git clone https://github.com/ExaFEL/exafel_project.git
git clone https://github.com/gigantocypris/SPREAD.git
libtbx.configure LS49 ls49_big_data uc_metrics lunus sim_erice xfel_regression
libtbx.refresh
cd $BUILD
mk-cctbx cuda build
```

Check out the following branches:
```
cd $MODULES/cctbx_project
git checkout nxmx_writer

cd $MODULES/dxtbx
git checkout nxmx_writer

cd $MODULES/exafel_project
git checkout syns-ml

cd $MODULES/LS49
git checkout experimental
```

Installation is complete! When starting up from a new Perlmutter terminal, run the following commands:
```
source ~/env_spread
cd $MODULES
cd ../
. activate.sh
```

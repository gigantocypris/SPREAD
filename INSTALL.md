# SPREAD
Serial femtosecond crystallography (SFX) for spatially resolved anomalous dispersion (SPREAD).


## Installation

NERSC_USERNAME
NERSC_GPU_ALLOCATION
CFS_ALLOCATION: m3562

Setup instructions on Perlmutter:

> export CFSW=$CFS/CFS_ALLOCATION/users/nersc_username
> mkdir $CFSW
> export CFSSRC=$CFSW/p20231 
> mkdir $CFSSRC
> cd $CFSSRC

> salloc -N 1 --time=120 -C gpu -A nersc_gpu_allocation --qos=interactive --ntasks-per-gpu=1
> module purge
> module load PrgEnv-gnu cpe-cuda cudatoolkit

> git clone https://github.com/JBlaschke/alcc-recipes.git alcc-recipes
> cd alcc-recipes/cctbx
> ./setup_perlmutter.sh 

Ignore returned errors.

> pwd

/global/cfs/cdirs/$CFS_ALLOCATION/users/$NERSC_USERNAME/p20231/alcc-recipes/cctbx

> rm opt/mamba/envs/psana_env/lib/libssh.so.4
> module load evp-patch

> source utilities.sh
> source opt/site/nersc_perlmutter.sh

> load-sysenv
> activate

> mk-cctbx cuda build

Test kokkos with the following (it works if you don't get an error):
>libtbx.python
> from simtbx import get_exascale
> g = get_exascale("exascale_api","kokkos_gpu")

> vi ~/env_spread

Copy the following into the file:

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

:wq

> source ~/env_spread
> cd /global/cfs/cdirs/m3562/users/nersc_username/p20231/alcc-recipes/cctbx

> vi activate.sh

Copy the following into the file:

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

:wq
> . activate.sh
> mk-cctbx cuda build


Test GPU usage:
> libtbx.python "/global/cfs/cdirs/$CFS_ALLOCATION/users/$NERSC_USERNAME/p20231/alcc-recipes/cctbx/modules/cctbx_project/simtbx/gpu/tst_shoeboxes.py" context=kokkos_gpu

At the same time in another window logged into the interactive session, do:
> watch -n 0.1 nvidia-smi

Watch the GPU usage to check that it increases. Printout of the code should look like this:
##############################
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

##############################

> cd $MODULES
> conda install -c conda-forge nxmx
> conda install -c conda-forge distro
> conda install pytorch==1.13.1 torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia
> git clone https://github.com/vganapati/LS49
> git clone https://gitlab.com/cctbx/ls49_big_data
> git clone https://gitlab.com/cctbx/uc_metrics
> git clone https://github.com/lanl/lunus            
> git clone https://github.com/dermen/sim_erice
> git clone https://gitlab.com/cctbx/psii_spread.git    
> git clone https://gitlab.com/cctbx/xfel_regression.git
> git clone https://github.com/ExaFEL/exafel_project.git
> git clone https://github.com/gigantocypris/SPREAD.git
> libtbx.configure LS49 ls49_big_data uc_metrics lunus sim_erice xfel_regression
> libtbx.refresh
> cd $BUILD
> mk-cctbx cuda build


Test again:
> libtbx.python "/global/cfs/cdirs/m3562/users/vidyagan/p20231/alcc-recipes/cctbx/modules/cctbx_project/simtbx/gpu/tst_shoeboxes.py" context=kokkos_gpu

At the same time in another window logged into the interactive session, do:
> watch -n 0.1 nvidia-smi

Watch the GPU usage to check that it increases.

##############################
Check out the following branches:

ExaFEL
cd $MODULES/cctbx_project --> nxmx_writer
cd $MODULES/dxtbx --> nxmx_writer
cd $MODULES/exafel_project --> experimental_rollback


##############################

Enter the following commands to start up from a new Perlmutter terminal:
source ~/env_spread
cd $MODULES
cd ../
. activate.sh


<br/>
<p align="center"><img src="imgs/logo.png" width=500 /></p>

----
![Crates.io](https://img.shields.io/crates/l/Ap?color=black)

# Self-Supervised Deep Learning for Model Correction in the Computational Crystallography Toolbox

## Overview

The Computational Crystallography Toolbox [cctbx]{.smallcaps} (\textsc{cctbx}) is open-source software that allows for processing of crystallographic data, including from serial femtosecond crystallography (SFX), for macromolecular structure determination. We aim to use the modules in \textsc{cctbx} to determine the oxidation state of individual metal atoms in a macromolecule. Changes in oxidation state are reflected in small shifts of the atom's X-ray absorption edge. These shifts can be extracted from the diffraction images recorded in serial femtosecond crystallography, given knowledge of the forward physics model. However, as the change in absorption edge is small, inaccuracies in the forward physics model obscure observation of the oxidation state. We describe the potential impact of using self-supervised deep learning to correct the scientific model in \textsc{cctbx} and provide uncertainty quantification. We provide code for forward model simulation and data analysis, built from \textsc{cctbx} modules, in this GitHub repository. Open questions in algorithm development are described to help spur advances through dialog between crystallographers and machine learning researchers. New methods could help elucidate charge transfer processes in many reactions, including key events in photosynthesis. 

Please see our full paper HERE.

## Table of Contents

1. [NERSC Accounts](#Installation)
2. [Synthetic Foam Dataset](#Foam)
3. [Synthetic 3-Dimensional MNIST Dataset](#MNIST)
4. [Experimental Dataset](#Experimental)

## NERSC Accounts <a name="foam"></a>

We highly recommend using the [National Energy Research Scientific Computing Center (NERSC)](https://www.nersc.gov) to run this code. The codes are optimized to run on [Perlmutter](https://docs.nersc.gov/systems/perlmutter/architecture/). To run code on NERSC, you need a [user account](https://docs.nersc.gov/accounts/#obtaining-an-account) and an [allocation](https://www.nersc.gov/users/accounts/allocations/). New users can apply for an [Exploratory Allocation](https://www.nersc.gov/users/accounts/allocations/first-allocation/) of 100 GPU node hours (a GPU node on Perlmutter has 1 CPU + 4 GPUs).

## Installation <a name="foam"></a>

To install required modules on Perlmutter, the NERSC supercomputer, please use these [instructions](INSTALL.md).

## Forward Model <a name="foam"></a>

In an SFX experiment, a microcrystal is imaged with an X-ray pulse. The crystal diffracts the X-ray radiation right before it is destroyed. The resulting diffraction image is known as a ``still shot.'' The known forward physics of an SFX experiment on photosystem II can be modeled, resulting in simulated diffraction images. To create a dataset of 100,000 still shots, run the following on Perlmutter:

> cd $WORK
> mkdir output_spread
> cd output_spread
> sbatch $MODULES/SPREAD/forward_model/slurm_create_images_kokkos.sh

After the job runs, the output log files can be viewed:

> cat *.log
> cat *.err

The output is saved in the $SCRATCH directory:

> cd $SCRATCH/psii_sim/images
> ls

example output...

Each h5 container stores multiple simulated images. To visualize:

> dials.image_viewer *.h5

Example simulated image. 

Note that the script models a Jungfrau detector, which can be modeled hierarchically (label the hierarchy).


## Conventional Processing <a name="foam"></a>

Indexing and integrating

Example indexed results (indexing finds the strong spots to determine orientation and unit cell)

example image

Integration uses the orientation found by indexing to determine where spots should be and draws boxes there

Example image

## Further Processing <a name="foam"></a>

By demonstrating the known forward physics and conventional methods of indexing and integration, we aim to spark discussion amongst machine learning researchers and crystallographers to create improved processing methods for SPREAD. We outline promising directions in our [paper](paper.pdf), please get in touch if you would like to discuss further!

## Citation <a name="citation"></a>

If you find this repository useful for your work, please cite:

V. Ganapati, D. Tchon, A. S. Brewster, N. K. Sauter. ``Self-Supervised Deep Learning for Model Correction in the Computational Crystallography Toolbox,'' [https://github.com/gigantocypris/SPREAD](https://github.com/gigantocypris/SPREAD), 2023.
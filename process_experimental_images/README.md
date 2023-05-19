# Processing of Experimental Data

Work in progress, see [processing of simulated data](scripts/processing_simulated_images.md).

Step 1: Process data in dials (including detector metrology optimization and unit cell filtering)

Step 2: TDER, scaling, merging. Result is structure factor amplitudes $| F_{\vv{h}} |$.

Step 3: Determine the structure (i.e. positions of all atoms of the molecule) with PHENIX (see notes in LS49) using an existing model as a starting point as well as the experimentally derived structure factor amplitudes $| F_{\vv{h}} |$. (for simulated data, can use the PDB file).

Step 4: Using the known structure from PHENIX, calculate the complex structure factor $ F_{\vv{h}} $, not including the anomalous correction terms

# Gentrius: Identifying equally scoring trees in phylogenomics with incomplete data
by Olga Chernomor, Christiane Elgert, and Arndt von Haeseler
2023

This repository contains Data and Code used in the manuscript: bioRxiv: https://doi.org/10.1101/2023.01.19.524678

### Gentrius - GENerating Trees from Incomplete Unrooted Subtrees
The Gentrius algorithm is implemented in IQ-TREE 2 (C++) and is available since version 2.2. The source code is available from https://github.com/iqtree/iqtree2.

1. System requirements
* All software dependencies and operating systems (including version numbers): IQ-TREE 2 is available for Windows/macOS/Linux (pre-compiled binaries are available from 
http://www.iqtree.org). All required libraries are distributed with the IQ-TREE 2.
* Versions the software has been tested on: Gentrius was tested in IQ-TREE v.2.2
* Any required non-standard hardware: none

2. Installation guide
* Instructions: Extensive instructions are available at http://www.iqtree.org/doc/Quickstart
* Typical install time on a "normal" desktop computer: installation from the source code takes about 15 mins

3. Demo
* Instructions to run on data: for the manual specific to analysis with Gentrius see [manual](https://github.com/OlgaChern/Gentrius_2023SM/blob/main/gentrius_manual.md)
* Expected output:
* Expected run time for demo on a "normal" desktop computer: analysis with Gentrius depending on dataset takes from milliseconds to days; default stopping threshold on CPU time used is 7 days

4. Instructions for use
* How to run the software on data from the manuscript: the script to run Gentrius on datasets without consensus tree is available in [run Gentrius](https://github.com/OlgaChern/Gentrius_2023SM/blob/main/auxiliary_scripts/script-run-main-stand-analysis-PER_DATASET.sh) and to run analysis with consensus tree [run consensus]()
* Reproduction instructions: the scripts used to analyse datasets from the manuscript are available at [reproduce bio script](https://github.com/OlgaChern/Gentrius_2023SM/blob/main/data_biological/script-run-gentrius.sh)


### Matrix Simulator - Generating 0/1 matrices
https://github.com/OlgaChern/MatrixSimulator

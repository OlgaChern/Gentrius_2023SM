# This repository contains Supplementary data for the manuscript
## "Identifying trees with equal scores in phylogenomics using Gentrius"
### by Olga Chernomor, Christiane Elgert, and Arndt von Haeseler
#### 2022


## Algorithm Gentrius - Generating trees from incomplete unrooted subtrees
---

## Implementation
---
Gentrius is implemented in IQ-TREE 2.

Manual (reference)

## Simulations
---
### Datasets
All simulated instances are provided in this repository (reference). One simulation instance is a matrix and a tree. For each matrix we generated 5 different trees.

### Matrices
To generate 0-1 matrices we developped a custom Matrix Simulator (reference). Matrix generation (parameters and corresponding command line) are described in full details here (reference).

### Trees
Binary unrooted random trees were generated using IQ-TREE 2 (reference) with command line

```bash
iqtree2 -r tree -k fhfjkflg
```

For each matrix 5 different random trees were generated. To assure that the trees are distinct we computed their pair-wise Robinson-Foulds distance using IQ-TREE 2

```bash
iqtree2 -rf_all trees
```


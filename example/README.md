## Example dataset

### Input
* tree file: `tree.nwk`
* matrix file: `matrix.txt`

### Command 
`iqtree2 --gentrius tree.nwk -pr_ab_matrix matrix.txt`

### Output
* log file: `tree.nwk.log`

```
IQ-TREE version 2.2.0 COVID-edition for Mac OS X 64-bit built Dec 14 2021 built Dec 14 2021
Developed by Bui Quang Minh, James Barbetti, Nguyen Lam Tung,
Olga Chernomor, Heiko Schmidt, Dominik Schrempf, Michael Woodhams, Ly Trong Nhan.

Host:    Admins-MacBook-Pro-9.local (AVX2, FMA3, 16 GB RAM)
Command: iqtree2 --gentrius tree.nwk -pr_ab_matrix matrix.txt vi README.md
Seed:    705611 (Using SPRNG - Scalable Parallel Random Number Generator)
Time:    Tue Feb 14 00:50:40 2023
Kernel:  AVX+FMA

NOTE: Consider using the multicore version because your CPU has 4 cores!

---------------------------------------------------------

Begin analysis with Gentrius...

---------------------------------------------------------
Notes:
- Gentrius generates a stand, i.e. a collection of species-trees, which display (also compatible with) the same loci subtrees
- If one of the stopping rules is triggered, the stand was not generated completely. You can change the thresholds or even turn them off to try generating all trees.
- If with default thresholds Gentrius did not generate any species-tree, use alternative exploratory approach (see manual).
---------------------------------------------------------
Partition 7 is chosen for the initial tree.
---------------------------------------------------------
Current stopping thresholds:
1. Stop if stand size reached: 1000000
2. Stop if the number of intermediate visited trees reached: 10000000
3. Stop if the CPU time reached: 604800 seconds
---------------------------------------------------------

READY TO GENERATE TREES FROM A STAND
using FORWARD approach (generates all trees, can be exponentially many)

---------------------------------------------------------
INPUT INFO:
---------------------------------------------------------
Number of taxa: 100
Number of loci: 30
Number of taxa with minimal coverage (row sum = 1): 0
% of missing entries in taxon per locus presence-absence matrix: 70.000
Number of taxa on initial tree: 46
Number of taxa to be inserted: 54
---------------------------------------------------------

Generating trees from a stand....

---------------------------------------------------------

Done!

---------------------------------------------------------
SUMMARY:
Number of trees on stand: 46575
Number of intermediated trees visited: 28983
Number of dead ends encountered: 3150
---------------------------------------------------------
Total wall-clock time used: 38.228 seconds (0h:0m:38s)
Total CPU time used: 37.836 seconds (0h:0m:37s)
```

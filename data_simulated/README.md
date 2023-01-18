### This repository contains simulated datasets

---
### Simulation 1: testing feasibility of Gentrius algorithm
One dataset consists of a presence-absence species per locus matrix and a binary unrooted tree.
For each matrix five different random trees were generated using IQ-TREE 2.

Matrices were generated using a custom Matrix simulator using the following parameters:

n - number of rows 		(i.e. species)		[20,50,100,300,700]
k - number of columns		(i.e. loci)		[5,10,30,100]
m - % of 0's in a matrix	(i.e. missing data)	[30%,50%,70%]

r0 - minimal number of 0's in each row (to control the presence of species without missing data)	[0,1]
c0 - minimal number (or %) of 0's in each col (i.e. missing entries per locus)	[1,10%,20%,50%]
u  - % of rows with row sum equals to 1	(i.e. minimally covered species)	[0%,5%,20%]

Nine basic types of distribution of missing data (zeros) in a matrix are defined by combinations of row and column sampling probabilities.
Namely, the Matrix simulator splits rows/columns into three categories according to user-defined fractions and assigns rows/columns by user-defined sampling probabilities for each category. For more details on the types and combinations of probabilities refer to the manuscript and its supplement.

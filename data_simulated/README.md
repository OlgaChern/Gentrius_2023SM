#This repository contains simulated datasets used in the article
###"Gentrius"

---
One dataset consists of a presence-absence species per locus matrix and a binary unrooted tree.
For each matrix five different random trees were generated using IQ-TREE 2 (reference). All five trees were pair-wise check

Matrices were generated using a custom Matrix simulator (reference) using the following parameters:

n - number of rows 		(i.e. species)		[20,50,100,300,700]
k - number of columns		(i.e. loci)		[5,10,30,100]
m - % of 0's in a matrix	(i.e. missing data)	[30%,50%,70%]

r0 - minimal number of 0's in each row (to control the presence of species without missing data)	[0,1]
c0 - minimal number (or %) of 0's in each col (i.e. missing entries per locus)	[1,10%,20%,50%]
u  - % of rows with row sum equals to 1	(i.e. minimally covered species)	[0%,5%,20%]

The following combinations of the last two parameters are used
* `u_0-c0_1` _(Note: this combination is used to define nine basic types of distribution of missing data in matrix.)_
* `u_0-c0_10`
* `u_0-c0_20`
* `u_0-c0_50` _(Note: since c0=50% requires at least 50% of missing data, this combination is not possible with 30% of missing data.)_
* `u_0-c0_1`


Nine basic types of distribution of missing data (zeros) in a matrix are defined by combinations of row and column sampling probabilities.
Namely, the Matrix simulator (reference) splits rows/columns into three categories according to user-defined fractions and assigns rows/columns by user-defined sampling probabilities for each category. The following table summarizes the parameters used to defined the nine types explored in the article:

| Example | Types | row fractions | row sampling probabilities | column fractions | column sampling probabilities |
| ------- | ----- |:-------------:| -----:|
|![](./docs/images/matrix_types/type_1.png)|1| | |
|![](./docs/images/matrix_types/type_2.png)|2| | |
|![](./docs/images/matrix_types/type_3.png)|3| | |
|![](./docs/images/matrix_types/type_4.png)|4| | |
|![](./docs/images/matrix_types/type_5.png)|5| | |
|![](./docs/images/matrix_types/type_6.png)|6| | |
|![](./docs/images/matrix_types/type_7.png)|7| | |
|![](./docs/images/matrix_types/type_8.png)|8| | |
|![](./docs/images/matrix_types/type_9.png)|9| | |


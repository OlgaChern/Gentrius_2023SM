#!/bin/bash
# ------------------------------------------------------------------------------------------------
# Location of iqtree binary
YOUR_PATH=/usr/local/bin/	# Change to your path for IQ-TREE
iqtree2=$YOUR_PATH/iqtree2
# ------------------------------------------------------------------------------------------------
# Working directory
f_work="gentrius_datasets_biological"	
# NOTE: if you run this script, it will overwrite ML trees in the gentrius_datasets_biological!!
# ------------------------------------------------------------------------------------------------
all_datasets="d180_15 d237_74 d267_20 d279_27 d298_3 d372_79 d381_13 d404_11 d435_18 d767_5"
# ------------------------------------------------------------------------------------------------
id=0
for d in $all_datasets
do
	id=$[$id+1]
	data=$d
	# ----------------------------------------------------------------------------------------
	f=$f_work/D${id}_${data}
	# ----------------------------------------------------------------------------------------
	# INPUTS
	aln=$f/${data}.aln
	part_info=$f/${data}.part_info
	pr_ab_matrix=$f/${data}.pr_ab_matrix
	tree=$f/${data}.ML.treefile
	# ----------------------------------------------------------------------------------------
	# OUTPUTS
	outfile=$f/${data}.gentrius
	outfile_matrix=$f/${data}
	outfile_print=$f/${data}.gentrius.PRINT
	stand_trees=$outfile_print.stand_trees
	# ----------------------------------------------------------------------------------------
	# For the manuscript we first built the presence-absence matrix and then used it as input. 
	# To skip this step use command line:
	# $iqtree2 --gentrius -s $aln -Q $part_info $tree -pre outfile -g_print_m
	# mv ${outfile}.pr_ab_matrix ${outfile_matrix}.pr_ab_matrix
	# ----------------------------------------------------------------------------------------
	# Build presence-absence matrix from alignment and partition info
	$iqtree2 --gentrius -s $aln -Q $part_info -pre $outfile_matrix -m_only

	# Analyse stand corresponding to pr_ab_matrix and tree (stopping thresholds are set to 100000000, remove corresponding options to set them to default)
	$iqtree2 --gentrius -pr_ab_matrix $pr_ab_matrix $tree -pre $outfile -g_stop_t 100000000 -g_stop_i 100000000
	stand_size="`grep "Number of trees on stand" ${outfile}.log | awk -F ": " '{print $2}'`"

	if [ "$stand_size" -le 150000 ] && [ "$stand_size" -gt 1 ]
	then
		# run wih print option
        	$iqtree2 --gentrius -pr_ab_matrix $pr_ab_matrix $tree -pre $outfile_print -g_print
		$iqtree2 -con -minsup 0.999999999999 -t $stand_trees
	fi
# ------------------------------------------------------------------------------------------------
done

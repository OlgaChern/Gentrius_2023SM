#!/bin/bash
#------------------------------------------------------------------------------------------------------------------------
#
#	DESCRIPTION: print stand trees and compute their strict consensus tree
#
#------------------------------------------------------------------------------------------------------------------------
# For a given tree and presence absence matrix this script performs stand analysis using Gentrius algorithm.
# It prints out all stand trees and computes strict consensus tree from them.
#
# WARNING: there can be millions of trees on a stand!!!!
# First run DEFAULT analysis to select reasonable datasets for PRINT+CONSENSUS analysis.
#
# NOTE: 
# For X taxa and Y trees IQ-TREE (v2.1) required *GB of memory for consensus tree construction. Size of file with stand trees *MB.
# 700 taxa | 500K trees: 250GB, 114MB
# 700 taxa | 100K trees: 50GB, 30MB
# 300 taxa | 50K  trees: 11GB, 4MB
# 100 taxa | 300K trees: 20GB, 7MB

#
# Usage:
# ./script-run-print_cons-stand-analysis-PER_DATASET.sh <pr_ab_matrix> <tree>
#
# IMPORTANT: you need to specify the path to iqtree2!!! Search for keyword: CHANGE
#
#------------------------------------------------------------------------------------------------------------------------
#
#       INPUT DATA
#
#------------------------------------------------------------------------------------------------------------------------
# INPUT 1: tree

# Requirements:
# - in Newick format
# - must be a bifurcating unrooted tree.
# HINT: You can check if your tree is bifurcating with:
# https://github.com/OlgaChern/Gentrius_2023SM/blob/main/auxiliary_scripts/script-plot-tree-with-marked-multifurcations.r

# Example of tree:
#
# (species_1,species_2,(species_3,(species_4,species_5)));
#
#------------------------------------------------------------------------------------------------------------------------
# INPUT 2: pr_ab_matrix

# Requirements:
# - 0/1 matrix
# - first row contains the number of species and the number of loci

# Example of pr_ab_matrix: 
#  5 3  
#  species_1 0 1 1  
#  species_2 1 0 1  
#  species_3 1 1 1  
#  species_4 1 1 0  
#  species_5 1 1 1  
#
#------------------------------------------------------------------------------------------------------------------------
# SUMMARY OUTPUTS:
# tree*.SUMMARY_TOPOLOGY     - a short summary about strict consensus tree
#------------------------------------------------------------------------------------------------------------------------
#
#	BINARIES/SCRIPTS
#
#---------------------------------------------------------------------------------
iqtree2="YOUR_PATH_TO/iqtree2" # CHANGE: the path to iqtree2 binary
#---------------------------------------------------------------------------------
#
#	FUNCTIONS
#
#---------------------------------------------------------------------------------
function check_if_run_finished {
        file=$1
        if [ ! -e $file ]
        then
                echo "ERROR: file - $file - does not exist!"
                exit
        else
                check="`grep "Date and Time" $file | wc -l | awk -F " " '{print $1}'`"
                if [ "$check" -ne 1 ]
                then
                        echo "ERROR: the run - $file - might have failed! Please, check."
                        exit
                fi
        fi
}
#---------------------------------------------------------------------------------
function summary_topology {
	file="$1"
	file_gentrius="$2"
	if [ ! -e "$file" ]
        then
                echo "ERROR: file - $file - does not exist!"
                exit
	else
		splits_remained=`grep "splits found" $file | awk -F " " '{print $1}'`
		if [ "$splits_remained" -ne "0" ]
                then
                	splits_ignored=0
                       	check=`grep "discarded because frequency" $file | wc -l | awk -F " " '{print $1}'`
                        if [ "$check" -gt 0 ]
                        then
                        	splits_ignored=`grep "discarded because frequency" $file | awk -F " " '{print $1}'`
                        fi

			if [ -e "$file_gentrius" ]
			then
				info="`cat $file_gentrius` | SPLITS_REMAINED $splits_remained SPLITS_IGNORED $splits_ignored"
			else
				info="$file | SPLITS_REMAINED $splits_remained SPLITS_IGNORED $splits_ignored"
			fi

			echo "$info" > $file.SUMMARY_TOPOLOGY

		else
                	echo "WARNING: Possibly an ERROR! There are $splits_remained!"
                fi
	fi
}
#---------------------------------------------------------------------------------
#
#	INPUTs 
#
#---------------------------------------------------------------------------------
pr_ab_matrix="$1"
tree="$2"

# INPUT CHECK:
if [ "$pr_ab_matrix" == "" ] || [ "$tree" == "" ]
then
	echo "ERROR: either matrix or a tree is not supplied!"
	exit
else
	if [ ! -e "$pr_ab_matrix" ]
	then
		echo "ERROR: matrix file - $pr_ab_matrix - does not exist!"
		exit
	fi

	if [ ! -e "$tree" ]
        then
                echo "ERROR: tree file - $tree - does not exist!"
                exit
        fi
fi
#---------------------------------------------------------------------------------
#
#	MAIN TOPOLOGICAL CHECK FOR STAND ANALYSIS
#
#---------------------------------------------------------------------------------
#
#	POST DEFAULT ANALYSIS
#
#---------------------------------------------------------------------------------
run_print_trees=ON
#---------------------------------------------------------------------------------
#
#	RUN: with print option and construct a consensus tree
#
#---------------------------------------------------------------------------------
if [ "$run_print_trees" == ON ]
then
	tag=PRINT
	file=${tree}.${tag}.all_gen_stand_trees
	$iqtree2 -gentrius -pr_ab_matrix $pr_ab_matrix $tree -pre ${tree}.${tag} -quiet -g_print
	check_if_run_finished ${tree}.${tag}.log
	# Build strict consensus tree - IQ-TREE
	$iqtree2 -con -minsup 0.9999999999999 -t ${tree}.${tag}.all_gen_stand_trees
	check_if_run_finished ${tree}.${tag}.all_gen_stand_trees.log
	summary_topology ${tree}.${tag}.all_gen_stand_trees.log ${tree}.DEFAULT.log.SUMMARY_gentrius
fi


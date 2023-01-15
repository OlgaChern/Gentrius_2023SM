#!/bin/bash
# ------------------------------------------------------------------------------------------------
# Location of iqtree binary
YOUR_PATH=/usr/local/bin/	# Change to your path for IQ-TREE
iqtree2=$YOUR_PATH/iqtree2
# ------------------------------------------------------------------------------------------------
# Working directory
f_work="gentrius_datasets_biological"
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
	# ---------------------------------------------------------------------------------------
	# OUTPUT
	trees_random=$f/${data}.random_all_trees
	if [ -e $trees_random ]
	then
		rm ${trees_random}*
	fi
	# ----------------------------------------------------------------------------------------
	sp_NUM=`echo $d | sed "s/d//g" | awk -F "_" '{print $1}'`
	for i in {1..100}
	do
		tree=$f/${data}.random_$i.treefile
		t=$f/${data}.random_$i
		if [ ! -e $tree ]
		then
			if [ ! -e $trees_random ]
			then
				# Generate a random tree
				$iqtree2 -r $sp_NUM -s $aln -pre $t $tree
			else
				success=NO
				while [ "$success" == "NO" ]
				do
					$iqtree2 -r $sp_NUM -s $aln -pre $t $tree
					$iqtree2 --gentrius -pr_ab_matrix $pr_ab_matrix $tree -g_query $trees_random
					
					check=`grep "" $tree.log | wc -l | awk -F " " '{print $1}'`
					exit
				done

			fi
			cat $tree >> $trees_random
		fi
		# ----------------------------------------------------------------------------------------
                # OUTPUTS
		outfile=$tree.gentrius
		# ----------------------------------------------------------------------------------------
		# Analyse stand corresponding to pr_ab_matrix and tree (stopping thresholds are set to 100000000, remove corresponding options to set them to default
		$iqtree2 --gentrius -pr_ab_matrix $pr_ab_matrix $tree -pre $outfile -g_stop_t 100000000 -g_stop_i 100000000
	done
	# Check, if all trees are different
	$iqtree2 -rf_all $trees_random
# ------------------------------------------------------------------------------------------------
done

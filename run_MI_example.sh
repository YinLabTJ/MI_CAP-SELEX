#!/bin/bash
# An example of create MI heatmap for our published CAP-SELEX matrices
# To run this pipeline, you need a batch file with TF_pairs information (File Batch_test is an example)and a folder (e.g. ./SELEX) that stores sequence file
# The sequence files should contain DNA sequence only, not fastq format. And the name of the sequence files should be consistent with the batch file.
# You can take "Batch_test.txt" and folder “SELEX" as an example


if [[ $# != 2 ]] && [[ $# != 3 ]];
then
	echo "usage: bash run_MI_example.sh batch_file seq_file_dir [filter_ind_TF_4mer]"
	exit
fi
#export PATH="$PATH:/data/software/MI_CAP-SELEX"

#1. run spacek40 
perl script/step1_spacek40.pl $1 $2

#2. pick top fold change k-mers and mark local_max information 
perl script/step2_top_local_max.pl $1

#3. pick top fold change k-mers in individual TF
perl script/step3.pick_top_fc.pl $1

#4. 6-mer and 8-mer filtering
perl script/step4.k-mer_filter.pl $1 $2

#5. computer 4-mer pairs frequency 
perl script/step5.4-mer_frequency.pl $2

#6. draw MI matrix
bash output/step6.sh

#Run step7 and step8 only when MI of TF pairs and individual TF were concentrated to same spacing
if [[ $# == 3 ]] && [[ $3 -eq "filter_ind_TF_4mer" ]];
then	
	#7 compute spacings of top 5% MI signals 
	perl script/step7_top5p_MI_signals.pl

	#8 filter 4-mer from iniividual TF motifs
	perl script/step8_filter_individual_TF_4-mer.pl Batch_test.txt SELEX
	bash output/step8_top5p_no_more_than_5_spacing.sh
	bash output/step8_top5p_no_more_than_5_spacing.shift.sh
fi


#remove temporary files
bash script/clean.sh

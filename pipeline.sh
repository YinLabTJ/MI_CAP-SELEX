export PATH="/data/TF_pairs/Zhiyuan:$PATH" #spacek40 path
perl step0_get_list.pl Batch_test.txt
perl step1_generate.pl /data/software/MI/upload_pipeline/SELEX # /data/software/MI/upload_pipeline/SELEX is the directory of seq files
sh step1_spacek40_sample.sh
sh step1_spacek40_pair.sh
perl step2_generate.pl
sh step2.sh
perl step3.generate.pl Batch_test.txt
sh step3.sh
perl step4.1_filter_fc.pl
perl step4.2_filter_hamming_distance.pl
perl step4.3_merge_and_filter_reads.pl Batch_test.txt /data/software/MI/upload_pipeline/SELEX
perl step5.generate.pl /data/software/MI/upload_pipeline/SELEX
cd output/
sh work.sh


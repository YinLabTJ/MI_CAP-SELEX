# MI_CAP-SELEX

<<<<<<< HEAD

Dependencies:

perl v5.26 or higher verion (SVG.pm required)
R 4.2.0 or higher version
spacek40


export PATH="$PATH:/data/software/MI_CAP-SELEX"  #add spacek40 path to your environment
export PERLLIB="$PERLLIB:/data/software/MI_CAP-SELEX/script" #add script path to perllib to use functions in MI.pm


Examples of analysis workflow:
1. Create your own Batch file
2. Save your sequence file (unique 40bp sequences only, not fastq format) in a directory like SELEX. These files' names should be consisted with the format of your Batch file
3. To run this pipeline, you could refer to run_MI_example.sh:
   bash run_MI_example.sh Batch_test.txt SELEX

   Optional parameter: If TF pairs and one of the individual TF are concentrated to same spacing, 4-mer pairs with highest frequency of this spacing need to be removed:
   bash run_MI_example.sh Batch_test.txt SELEX filter_ind_TF_4mer
   This iteration step may take much more time, add this parameter only when necessary

4. You can use Batch_test.txt and SELEX/*.seq as demo data and directly run pipeline.sh, it will take about 25 minutes to finish the pipeline without filtering individual TF 4-mer step.
   If parameter "filter_ind_TF_4mer" is set, the process of demo data should take about 2 hours.

5. Expected output:
   SVG files of each pair of Transcription Factors drawing MI matrix and other information will be created in directory 'output/MI_figures/' .
 
>>>>>>> 213e9825110fbf5f67ccdea5f07059035490880a

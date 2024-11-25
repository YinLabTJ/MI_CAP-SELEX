# MI_CAP-SELEX

<<<<<<< HEAD
Dependency:
perl    v5.26.1 or higher version, perl extension SVG.pm required
R       v4.1.2 or higher version

export PATH="$PATH:/data/software/MI_CAP-SELEX"  #add spacek40 path to environment
export PERLLIB="$PERLLIB:/data/software/MI_CAP-SELEX/script" #add script path to perllib to use functions in MI.pm

To run this pipeline, please refer to run_MI_example.sh:
bash run_MI_example.sh Batch_test.txt SELEX

=======
Dependencies:

perl v5.26 or higher verion (svg.pm required), R 4.2.0 or higher version, spacek40

Examples of analysis workflow:
1. Create your own Batch file
2. Save your sequence file (sequences only, not fastq format) in a directory like SELEX. These files' names should be consisted with the format of your Batch file
3. pipeline.sh is an example of running the pipeline step by step.
4. You can use Batch_test.txt and SELEX/*.seq as demo data and directly run pipeline.sh, it will take about 60 minutes to finish the pipeline.

Expected output:
SVG files of each pair of Transcription Factors drawing MI matrix and other information, in directory 'output/MI_figures' .
 
>>>>>>> 213e9825110fbf5f67ccdea5f07059035490880a

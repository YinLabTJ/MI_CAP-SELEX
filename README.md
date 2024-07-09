# MI_CAP-SELEX

Dependencies:

perl v5.26 or higher verion (svg.pm required), R 4.2.0 or higher version, spacek40

Examples of analysis workflow:
1. Create your own Batch file
2. Save your sequence file (sequences only, not fastq format) in a directory like SELEX. These files' names should be consisted with the format of your Batch file
3. pipeline.sh is an example of running the pipeline step by step.
4. You can use Batch_test.txt and SELEX/*.seq as demo data and directly run pipeline.sh, it will take about 60 minutes to finish the pipeline.

Expected output:
SVG files of each pair of Transcription Factors drawing MI matrix and other information, in directory 'output/Huddinge_final' .
 

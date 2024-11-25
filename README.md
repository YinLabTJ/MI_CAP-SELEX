# MI_CAP-SELEX

Dependency:
perl    v5.26.1 or higher version, perl extension SVG.pm required
R       v4.1.2 or higher version

export PATH="$PATH:/data/software/relative_affinity/upload_pipeline"  #add spacek40 path to environment
export PERLLIB="$PERLLIB:/data/software/MI/git_up/MI_CAP-SELEX/script" #add script path to perllib to use functions in MI.pm

To run this pipeline, please refer to run_MI_example.sh:
bash run_MI_example.sh Batch_test.txt SELEX

the output tables and figures should be in output/MI_figures/

#!/bin/bash
#$ -cwd
#$ -j y
#$ -l h_data=16G,h_rt=8:00:00
#$ -M <YOUR_EMAIL_HERE>
#  Notify at beginning and end of job
#$ -m bea

source /u/local/Modules/default/init/modules.sh
module load gcc/4.9.3

export PATH=/u/project/xyang123/shared/tools/10XGenomics/Software/cellranger-2.0.1:$PATH
export PATH=/u/project/xyang123/shared/tools/10XGenomics/bcl2fastq/bin:$PATH

cd /u/home/d/darneson/nobackup-xyang123/10X_Single_Cell/LusisCollab/runs/Set1

cellranger mkfastq \
--id=Mkfastq \
--run=/u/home/d/darneson/nobackup-xyang123/10X_Single_Cell/LusisCollab/bcl-9-13-2017/LVrfFiltYAP029L7/170913_K00208_0152_AHJV2FBBXX_YAP029/ \
--samplesheet=/u/home/d/darneson/nobackup-xyang123/10X_Single_Cell/LusisCollab/SampleInfo/cellranger-LiverAorta-bcl-samplesheet.csv \
--ignore-dual-index

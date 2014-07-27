#!/bin/bash
#$ -q short
#$ -j y
#$ -cwd
#$ -l h_vmem=20G
#$ -l virtual_free=20G
#$ -N md
. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

f=(data/yeast/*bam) #10
python mark_duplicates.py ${f["SGE_TASK_ID"-1]} 

#!/bin/bash
#$ -q short
#$ -j y
#$ -cwd
#$ -l h_vmem=4G
#$ -l virtual_free=4G
#$ -N recode
. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

f=(data/yeast/*R1_001.fastq.gz) #10
base=$(basename ${f["SGE_TASK_ID"-1]} R1_001.fastq.gz)
read1=${f["SGE_TASK_ID"-1]}
index="data/yeast/"$base"I1_001.fastq.gz"

python code_reads_se.py $read1 $index
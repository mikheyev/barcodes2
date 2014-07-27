#!/bin/bash
#$ -q short
#$ -j y
#$ -cwd
#$ -N map
#$ -l h_vmem=10G
#$ -l virtual_free=10G
. $HOME/.bashrc
a=(data/yeast/*R1_001.indexed.fastq.gz)
bowbase=data/yeast_ref/s288c
f=${a["SGE_TASK_ID"-1]}
base=`echo $(basename $f) | cut -d "_" -f 1`

bowtie2 -p 6 --sam-rg ID:$base --sam-rg LB:newRad --sam-rg SM:$base --sam-rg PL:ILLUMINA -x $bowbase -U $f | samtools view -Su  - | novosort --ram 5G -c 6 -t /genefs/MikheyevU/temp -i -o data/yeast/$base.bam -


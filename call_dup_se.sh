#!/bin/bash
#$ -q long
#$ -j y
#$ -cwd
#$ -N dup
#$ -l h_vmem=10G
#$ -l virtual_free=10G

. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

MAXMEM=8
ref=data/yeast_ref/s288c.fasta

samtools mpileup -ugf data/yeast_ref/s288c.fasta `ls -1 data/yeast/*.bam |grep -v nodup | tr "\n" " "` | bcftools view -s samples.txt -vcg - | vcfutils.pl varFilter -Q 20 > data/yeast/dup.vcf 
samtools mpileup -ugf data/yeast_ref/s288c.fasta data/yeast/*nodup.bam | bcftools view -s samples.txt -vcg - | vcfutils.pl varFilter -Q 20 > data/yeast/nodup.vcf
#!/bin/bash
#$ -q genomics
#$ -j y
#$ -cwd
#$ -N both
#$ -l h_vmem=10G
#$ -l virtual_free=10G

. $HOME/.bashrc
export TEMPDIR=/genefs/MikheyevU/temp
export TEMP=/genefs/MikheyevU/temp
export TMP=/genefs/MikheyevU/temp

MAXMEM=8
ref=~/was/final/scf.fa
alias GA="java -Xmx"$MAXMEM"g -Djava.io.tmpdir=/genefs/MikheyevU/temp -jar /apps/MikheyevU/sasha/GATK/GenomeAnalysisTK.jar"
alias picard="java -Xmx"$MAXMEM"g -Djava.io.tmpdir=/genefs/MikheyevU/temp -jar /apps/MikheyevU/picard-tools-1.66/"

inputs="-I data/dup.recal.bam -I data/nodup.recal.bam"

# Base calling 
GA -nct 20  \
   -T HaplotypeCaller\
   -R $ref \
   $inputs \
   --genotyping_mode DISCOVERY \
   -o data/both.vcf

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
ref=~/was/final/scf.fa
alias GA="java -Xmx"$MAXMEM"g -Djava.io.tmpdir=/genefs/MikheyevU/temp -jar /apps/MikheyevU/sasha/GATK/GenomeAnalysisTK.jar"
alias picard="java -Xmx"$MAXMEM"g -Djava.io.tmpdir=/genefs/MikheyevU/temp -jar /apps/MikheyevU/picard-tools-1.66/"

inputs=`for i in ./data/*_nodup.bam ; do echo -ne "-I "$i" "; done | sed  's/_nodup//g'`

# Applying base quality recalibration using the set of sites found by both callers

GA \
   -nct 12 \
   -T BaseRecalibrator \
   $inputs  \
   -R $ref \
   -knownSites data/poly_snps.vcf \
   -o data/dup.recal_data.table

# Prining recalibrated BAM file

 GA \
    -nct 12 \
    -T PrintReads \
    $inputs \
    -R $ref  \
    -BQSR data/dup.recal_data.table \
    -o data/dup.recal.bam

# Preparing comparison between recalibrated and non-recalibrated data

GA \
   -nct 12 \
   -T BaseRecalibrator \
   -I data/dup.recal.bam  \
   -R $ref \
   -knownSites data/poly_snps.vcf \
   -BQSR data/dup.recal_data.table \
   -o data/dup.post_recal_data.table

# Preparing PDF files with comparison between recalibrated and non-recalibrated data

GA \
    -T AnalyzeCovariates \
    -R $ref \
    -before data/dup.recal_data.table \
    -after data/dup.post_recal_data.table \
    -plots data/dup.recalibration_plots.pdf

# Base calling 
GA -nct 12 \
   -T HaplotypeCaller\
   -R $ref \
   $inputs \
   --genotyping_mode DISCOVERY \
   -o data/dup.vcf

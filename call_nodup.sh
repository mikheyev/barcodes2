#!/bin/bash
#$ -q genomics
#$ -j y
#$ -cwd
#$ -N nodup
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

inputs=`for i in ./data/*_nodup.bam ; do echo -ne "-I "$i" "; done`

# Applying base quality recalibration using the set of sites found by both callers

GA \
   -nct 12 \
   -T BaseRecalibrator \
   $inputs  \
   -R $ref \
   -knownSites data/poly_snps.vcf \
   -o data/nodup.recal_data.table

# Prining recalibrated BAM file

 GA \
    -nct 12 \
    -T PrintReads \
    $inputs \
    -R $ref  \
    -BQSR data/nodup.recal_data.table \
    -o data/nodup.recal.bam

# Preparing comparison between recalibrated and non-recalibrated data

GA \
   -nct 12 \
   -T BaseRecalibrator \
   -I data/nodup.recal.bam  \
   -R $ref \
   -knownSites data/poly_snps.vcf \
   -BQSR data/nodup.recal_data.table \
   -o data/nodup.post_recal_data.table

# Preparing PDF files with comparison between recalibrated and non-recalibrated data

GA \
    -T AnalyzeCovariates \
    -R $ref \
    -before data/nodup.recal_data.table \
    -after data/nodup.post_recal_data.table \
    -plots data/nodup.recalibration_plots.pdf

# Base calling 
GA -nct 12 \
   -T HaplotypeCaller\
   -R $ref \
   $inputs \
   --genotyping_mode DISCOVERY \
   -o data/nodup.vcf

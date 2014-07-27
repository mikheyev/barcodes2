# Detecting PCR duplicates using samples with individually barcoded reads

- These are double-digest RAD tags from *Wasmannia auropunctata* workers, amplified 18 and 25 cycles.
- The barcodes correspond to the last 4 bases of the I1 read.
- The scripts below are ordered in the order in which they are executed by the bioinformatic pipeline.

## **hq_snp.py**
- extract high quality SNPs from re-sequenced queen clone genome

## **code_reads.py**
- attach the barcode bases to the description of each read
- launched on SGE by **code.sh**

## **align.sh**
- use bowtie2 to map reads

## **mark_duplicates.py**
- remove duplicate reads, keeping the one with the highest mean quality
- launched by **mark_duplicates.sh** on SGE

## **call_dup.sh** and **call_nodup.sh**
- preform SNP calling on duplicated and non-duplicated libraries
- after snps have been called, they can be intersected with the file produced by **hq_snp.py**

## Now we intersect our high quality parental SNPs with those called from the RAD-tag data

    cd data
    intersectBed -a nodup.vcf -b poly_snps.vcf -wa -sorted > nodup_poly.vcf
    intersectBed -a dup.vcf -b poly_snps.vcf -wa -sorted > dup_poly.vcf

## **count_errors.py**
- score correctly marked genotypes in the two vcf files above into a file suitable for analysis by R (**data/errors.csv**)

## **dupl_errors.r**
- statistical analysis
    
    
# Test using yeast

**code_se.sh** and **code_reads_se.py** are yeast-specific versions of the utilities above

	samtools mpileup -ugf dgri/scaffolds.bases merged.bam | bcftools view -vcg - | vcfutils.pl varFilter -Q 20 > merged.vcf

	vcftools --recode --vcf nodup.vcf --remove-indels --max-alleles 2 --minGQ 20 --max-missing-count 1  --out nodup_nomissing

After filtering, kept 482 out of a possible 2870 Sites

	vcftools --recode --vcf dup.vcf --remove-indels --max-alleles 2 --minGQ 20 --max-missing-count 1  --out dup_nomissing

After filtering, kept 443 out of a possible 3958 Sites

	intersectBed -wa -a dup_nomissing.recode.vcf -b nodup_nomissing.recode.vcf > dup_intersect.vcf
	intersectBed -wa -a nodup_nomissing.recode.vcf -b dup_nomissing.recode.vcf > nodup_intersect.vcf


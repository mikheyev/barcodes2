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

    intersectBed -a nodup.vcf -b poly_snps.vcf -wa -sorted > nodup_poly.vcf
    intersectBed -a dup.vcf -b poly_snps.vcf -wa -sorted > dup_poly.vcf
    
## **count_errors.py**
- score correctly marked genotypes in the two vcf files above into a file suitable for analysis by R (**data/errors.csv**)

## **dupl_errors.r**
- statistical analysis
    
    
    
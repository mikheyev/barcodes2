# Detecting PCR duplicates using samples with individually barcoded reads

- These are double-digest RAD tags from *Wasmannia auropunctata* workers, amplified 18 and 25 cycles.
- The barcodes correspond to the last 4 bases of the I1 read.

## **code_reads.py**
- attach the barcode bases to the description of each read
- launched on SGE by **code.sh**

## **align.sh**
- use bowtie2 to map reads

## **mark_duplicates.py**
- remove duplicate reads, keeping the one with the highest mean quality
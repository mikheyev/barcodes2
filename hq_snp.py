from collections import Counter
import pdb 
"""read SNPs and get loci the queen is homozygous, and different from the male genotype. Return VCF file with the proper SNP sites"""
skips = Counter() #diagnostics
for line in open("data/snps.vcf"):
	if line[0] == "#":
		if not line.split()[0] == "#CHROM":
			print line,
		else:
			print "\t".join(line.split()[0:9]+[line.split()[-4]])
		continue
	gq = line.split()[8].split(":").index("GQ") #index of GQ
	gt = line.split()[-4] #the fourth record is the hawaii queen
	if gt == './.': #use only loci without missing data
		skips['missing'] += 1
		continue
	geno = gt.split(":")[0]
	qual = int(gt.split(":")[gq])
	if qual < 30:  #omit loci with low quality genotypes
		skips['lowqual'] += 1
		continue
	if geno == "0/1": #omit loci where queens are heterozygous
		skips['heterozygous'] += 1
		continue
	if geno == "0/0": #omit loci where queens and males are the same
		skips['invariant'] += 1
		continue
	skips['good'] += 1
	print "\t".join(line.split()[0:9]+[line.split()[-4]])

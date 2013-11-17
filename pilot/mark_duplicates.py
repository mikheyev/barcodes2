import pysam, collections
import sys,glob,pdb

""" 
Use the barcode introduced by code_reads.py to mark duplicate RAD-seq reads. Writes results into ./data/ folder.
Each read is identified by its start position, and the barcode. For duplicate reads, we keep the one with the highest mean quality.
"""

def mean_qual(qual):
	""" return the average quality of a read """
	total_quality = 0.0
	for base in qual:
		total_quality += ord(base)-33
	return total_quality/len(qual)

infile = sys.argv[1]
reads = collections.defaultdict(dict) # dictionary with start positions as keys, containig dictionaries with read id : quality pairs
name = infile.split("/")[-1].split(".")[0]
samfile = pysam.Samfile(infile,"rb")
duplicates = 0 
total = 0

# first pass, identify read duplicates, and choose those with the highest quality
for read in samfile:
	if not read.is_unmapped:
		quality = mean_qual(read.qqual)
		barcode = read.qname.split("_")[-1]
		total += 1
		if read.is_reverse: 
			start = read.positions[0]*-1
		else:
			start = read.positions[0]
		# check if there there are already reads that start at this position
		chrom_pos = (read.tid, start) # (chromosome, position)
		if chrom_pos in reads:
			# check if the same barcode already present
			for read_id in reads[chrom_pos]:
				if barcode == read_id.split("_")[-1]:
					duplicates += 1
					# pick better read, if there are duplicates
					if quality > reads[chrom_pos][read_id]:
						del reads[chrom_pos][read_id]
						reads[chrom_pos][read.qname] = quality
				continue
		else:
			reads[chrom_pos][read.qname] = quality

print "%s: %i total and %i duplicate reads: %s duplication" % (name, total,duplicates, "{0:.2f}%".format(100.0*duplicates/total))
samfile.close()

# second pass, only print reads that don't have duplicates
samfile = pysam.Samfile(infile,"rb")
out = pysam.Samfile("data/" + name + "_nodup.bam", "wb", template=samfile)
for read in samfile:
	if not read.is_unmapped:
		if read.is_reverse: 
			start = read.positions[0]*-100
		else:
			start = read.positions[0]
		if read.qname in reads[(read.tid, start)]:
			out.write(read)
out.close()
samfile.close()


import gzip,sys
from Bio import SeqIO
from itertools import izip
import pdb

"""
Take a single-end read file, and a file of index reads. Add the last four bases of each read to the sequence id.
"""

outfile = gzip.open(".".join(sys.argv[1].split(".")[0:-2]+["indexed","fastq","gz"]),"w")

for reads, index in izip(SeqIO.parse(gzip.open(sys.argv[1]),"fastq"), \
		SeqIO.parse(gzip.open(sys.argv[2]),"fastq")):
	reads.id += "_" + str(index.seq[7:])
	reads.description = reads.description.split()[-1]
	SeqIO.write(reads, outfile, "fastq")

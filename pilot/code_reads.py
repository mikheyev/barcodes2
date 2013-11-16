import gzip,sys
from Bio import SeqIO
from itertools import izip

"""
Take two paired end read files, and a file of index reads. Add the last four bases of each read to the sequence description.
"""

outfiles = []
for i in [1,2]:
	outfiles.append(gzip.open(".".join(sys.argv[i].split(".")[0:-2]+["indexed","fastq","gz"]),"w"))

reads = [1,2]
for reads[0], reads[1], index in izip(SeqIO.parse(gzip.open(sys.argv[1]),"fastq"), \
		SeqIO.parse(gzip.open(sys.argv[2]),"fastq"), \
		SeqIO.parse(gzip.open(sys.argv[3]),"fastq")):
	for i in range(2):
		reads[i].description = str(index.seq[7:]) + " " + reads[i].description.split()[-1]
		SeqIO.write(reads[i], outfiles[i], "fastq")

import gzip, glob, re, pdb
from Bio import SeqIO

proper = re.compile("[^ACTG]")

#initialize counter with zeros
combos = dict()
for i in ["A","C","T","G"]:
	for j in ["A","C","T","G"]:
		for k in ["A","C","T","G"]:
			for l in ["A","C","T","G"]:
				combos[i+j+k+l] = 0

for file in glob.glob("data/*I1_001.fastq.gz"):
	infile = gzip.open(file)
	for rec in SeqIO.parse(infile,"fastq"):
		idx = str(rec.seq[7:])
		if proper.match(idx):
			continue
		combos[idx]+=1
	infile.close()


total = float(sum(combos.values()))

for i in combos:
	print "%s: %f" % (i, combos[i]/total)

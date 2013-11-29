""" reads VCF files with with data from libraries with and without duplicates, and checks whether genotypes were called correctly """

individual = map(str,range(1,6)*2)
cycle = ["18"]*5 + ["25"]*5

print ",".join(["locus","treatment","individual","cycle","gq","correct"])
for treatment,infile in zip(["dup","nodup"],["data/dup_poly.vcf","data/nodup_poly.vcf"]):
	for line in open(infile):
		line = line.rstrip().split()
		gq = line[8].split(":").index("GQ") #index of GQ
		for idx,sample in enumerate(line[9:]):
			if sample == "./.":
				continue
			sample = sample.split(":")
			if sample[0] == "0/1":
				correct = "1"
			else:
				correct = "0"
			print ",".join([line[0]+"_"+line[1], treatment,individual[idx],cycle[idx],sample[gq],correct])

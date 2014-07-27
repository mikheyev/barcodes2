""" reads VCF files with with data from libraries with and without duplicates, and checks whether genotypes were called correctly """

# 14cycle3615adc2	14cycleDiploid1	14cycleDiploid2	14cycleDiploid3	14cycleSii	18cycle3615adc2	18cycleDiploid1	18cycleDiploid2	18cycleDiploid3	18cycleSii

individual = ['SK1',1,2,3,'S288c','SK1',1,2,3,'S288c']
cycle = ["14"]*5 + ["18"]*5

print ",".join(["locus","treatment","individual","cycle","gq","correct"])
for treatment,infile in zip(["dup","nodup"],["data/yeast/dup_intersect.vcf","data/yeast/nodup_intersect.vcf"]):
	for line in open(infile):
		line = line.rstrip().split()
		gq = line[8].split(":").index("GQ") #index of GQ
		#make sure parent genotypes are concordant
		if line[9:][0].split(":")[0] == line[9:][5].split(":")[0] and line[9:][4].split(":")[0] == line[9:][9].split(":")[0]:
			# make sure parental genotypes are different
			if (line[9:][0].split(":")[0] == "1/1" and line[9:][4].split(":")[0] == "0/0") or \
			(line[9:][0].split(":")[0] == "0/0" and line[9:][4].split(":")[0] == "1/1"):
				for idx,sample in enumerate(line[9:]):
					if idx in [0,5,4,9]:
						#skip parents
						continue
					if sample == "./.":
						continue
					sample = sample.split(":")
					if sample[0] == "0/1":
						correct = "1"
					else:
						correct = "0"
					print ",".join([line[0]+"_"+line[1], treatment,str(individual[idx]),cycle[idx],sample[gq],correct])

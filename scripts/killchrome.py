import os

cmd = "ps -e | rg chrom | awk '{print $1}'"

chromes = os.popen(cmd).readlines()

print(chromes)

for p in chromes:
    proc = p.replace("\n", "")
    os.system(f"kill {proc}")

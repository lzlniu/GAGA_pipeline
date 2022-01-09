import sys
from Bio import SeqIO
SeqIO.write(SeqIO.parse(sys.argv[1], "nexus"), sys.argv[2], "fasta")

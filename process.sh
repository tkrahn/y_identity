

# Make a "female" reference sequence and a chrY reference separately:
./generate_refs.sh &

# Chop the hg38 chrY reference sequence in 150 bp long tiles, 1bp shift
# This takes a long time so process in parallel as good as possible
./generate_fasta_tiles.sh &
wait

# Convert the fasta to fastq, compress:
./fasta_to_fastq.pl chrY_tiles.fasta | pigz > chrY_tiles.fastq.gz
# Source: https://github.com/ekg/fasta-to-fastq

# Map the tiles with BWA MEM to the complete female genome and to chrY 
# separately, allowing secondary mappings.
# Combine them to one BAM file, sort and index
./map_tiles.sh
# Wow! Just 1616 seconds! ~27 minutes

# Create a GFF3 file, sort, compress, index:
samtools view tiles_remap_sorted.bam | \
	./generate_gff3.pl >chrY_secondary_identities.gff3

(grep ^"#" chrY_secondary_identities.gff3; \
	grep -v ^"#" chrY_secondary_identities.gff3 | sort -k1,1 -k4,4n) | \
	bgzip > chrY_secondary_identities.gff3.bgz
tabix -p gff chrY_secondary_identities.gff3.bgz

# Create Wiggle / BigWig files
samtools view tiles_remap_sorted.bam | \
	./generate_wig.pl >chrY_secondary_identities.wig

./wigToBigWig \
	chrY_secondary_identities.wig \
	hg38.chrom.sizes \
	chrY_secondary_identities.bw

# access the identity score for L21 as an example:
tabix chrY_secondary_identities.gff3.bgz ChrY:13542548-13542548

# returns:









# Sources: 



#check how many lines (~features) do we have in the gff3?
wc -l chrY_secondary_identities.gff3
# should be: 9169433
tabix chrY_secondary_identities.gff3.bgz ChrY | wc -l
# should be: 9195759 (sans header)


#!/bin/bash
START=$(date +%s.%N)

rm -f chrY_tiles.fasta.gz
ref="/genomes/0/refseq/hg38/hg38.fa"

chr="chrY"
# 23891735 bases total (excluding PAR and Yq12)

for i in {2781479..26673214..80}
do
	# Split into 80 threads
	for j in {0..79} 
	do
		pos_start=$((${i} - 75 + ${j}))
		pos_end=$((${i} + 75 + ${j}))
		samtools faidx ${ref} ${chr}:${pos_start}-${pos_end} >> chrY_tiles_${j}.fasta &
	done
	wait
	
done
cat chrY_tiles_*.fasta >> chrY_tiles.fasta
rm -f chrY_tiles_*.fasta



#for i in {2781479..10072350..80}
#do
#	# Split into 80 threads
#	for j in {0..79} 
#	do
#		pos_start=$((${i} - 75 + ${j}))
#		pos_end=$((${i} + 75 + ${j}))
#		samtools faidx ${ref} ${chr}:${pos_start}-${pos_end} >> chrY_tiles_${j}.fasta &
#	done
#	wait
#	
#done
#cat chrY_tiles_*.fasta | pigz >> chrY_tiles.fasta.gz
#rm -f chrY_tiles_*.fasta


#for i in {11686750..20054914..80}
#do
#	# Split into 80 threads
#	for j in {0..79} 
#	do
#		pos_start=$((${i} - 75 + ${j}))
#		pos_end=$((${i} + 75 + ${j}))
#		samtools faidx ${ref} ${chr}:${pos_start}-${pos_end} >> chrY_tiles_${j}.fasta &
#	done
#	wait
#	
#done
#cat chrY_tiles_*.fasta | pigz >> chrY_tiles.fasta.gz
#rm -f chrY_tiles_*.fasta


#for i in {20351054..26637971..80}
#do
#	# Split into 80 threads
#	for j in {0..79} 
#	do
#		pos_start=$((${i} - 75 + ${j}))
#		pos_end=$((${i} + 75 + ${j}))
#		samtools faidx ${ref} ${chr}:${pos_start}-${pos_end} >> chrY_tiles_${j}.fasta &
#	done
#	wait
#	
#done
#cat chrY_tiles_*.fasta | pigz >> chrY_tiles.fasta.gz
#rm -f chrY_tiles_*.fasta


END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo ${DIFF}
exit 


#!/bin/bash
START=$(date +%s.%N)

NUM_THREADS=$(getconf _NPROCESSORS_ONLN)
echo "We can use ${NUM_THREADS} threads."

#Needed files
REF_PREFIX="/genomes/0/refseq/hg38"
REF_FEMALE="${REF_PREFIX}/hg38_female.fa"
REF_Y="${REF_PREFIX}/chrY.fa"

FASTQFILE="chrY_tiles.fastq.gz"

BAMFILE_FEMALE="tiles_remap_female.bam"
BAMFILE_Y="tiles_remap_Y.bam"
BAMFILE="tiles_remap.bam"
BAMFILE_SORTED="tiles_remap_sorted.bam"

# For a 95% identity we assume a mapping score of 150 * 0.95 = 142

bwa mem -T 142 -t ${NUM_THREADS} -M ${REF_FEMALE} ${FASTQFILE} | \
samtools view -@ ${NUM_THREADS} -b -t ${REF_FEMALE} -o ${BAMFILE_FEMALE} -
# 883.356 sec

bwa mem -a -T 142 -t ${NUM_THREADS} -M ${REF_Y} ${FASTQFILE} | \
samtools view -@ ${NUM_THREADS} -b -t ${REF_Y} -o ${BAMFILE_Y} -
# 133.885 sec

samtools merge ${BAMFILE} ${BAMFILE_FEMALE} ${BAMFILE_Y}

samtools sort -@ ${NUM_THREADS} -T /dev/shm/sorted -o ${BAMFILE_SORTED} ${BAMFILE}
samtools index ${BAMFILE_SORTED}

samtools idxstats $BAMFILE_SORTED > ${BAMFILE_SORTED}.idxstats.tsv 

END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo ${DIFF}
exit 



# Commets on BWA-MEM parameters:


#-a Output all found alignments for single-end or unpaired paired-end reads. These alignments will be flagged as secondary alignments. 

#-T INT Don’t output alignment with score lower than INT. This option only affects output. [30] 
#-T sets a threshold on the alignment score, not mapping quality. Alignment score is shown in the AS:i: SAM tag. The alignment score is determined by the scoring scheme, which is specified by -A, -B, -O and -E.

#samtools view -f 0x100 filters secondary mapped reads only. (removed)

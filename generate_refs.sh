#!/bin/bash
START=$(date +%s.%N)

# Needed file
REF_PREFIX="/genomes/0/refseq/hg38"
REF="${REF_PREFIX}/hg38.fa"

# Generated file
REF_FEMALE="${REF_PREFIX}/hg38_female.fa"

# Split to individual chromosomes
#samtools faidx ${REF} chr1 > ${REF_PREFIX}/chr1.fa &
#samtools faidx ${REF} chr2 > ${REF_PREFIX}/chr2.fa &
#samtools faidx ${REF} chr3 > ${REF_PREFIX}/chr3.fa &
#samtools faidx ${REF} chr4 > ${REF_PREFIX}/chr4.fa &
#samtools faidx ${REF} chr5 > ${REF_PREFIX}/chr5.fa &
#samtools faidx ${REF} chr6 > ${REF_PREFIX}/chr6.fa &
#samtools faidx ${REF} chr7 > ${REF_PREFIX}/chr7.fa &
#samtools faidx ${REF} chr8 > ${REF_PREFIX}/chr8.fa &
#samtools faidx ${REF} chr9 > ${REF_PREFIX}/chr9.fa &
#samtools faidx ${REF} chr10 > ${REF_PREFIX}/chr10.fa &
#samtools faidx ${REF} chr11 > ${REF_PREFIX}/chr11.fa &
#samtools faidx ${REF} chr12 > ${REF_PREFIX}/chr12.fa &
#samtools faidx ${REF} chr13 > ${REF_PREFIX}/chr13.fa &
#samtools faidx ${REF} chr14 > ${REF_PREFIX}/chr14.fa &
#samtools faidx ${REF} chr15 > ${REF_PREFIX}/chr15.fa &
#samtools faidx ${REF} chr16 > ${REF_PREFIX}/chr16.fa &
#samtools faidx ${REF} chr17 > ${REF_PREFIX}/chr17.fa &
#samtools faidx ${REF} chr18 > ${REF_PREFIX}/chr18.fa &
#samtools faidx ${REF} chr19 > ${REF_PREFIX}/chr19.fa &
#samtools faidx ${REF} chr20 > ${REF_PREFIX}/chr20.fa &
#samtools faidx ${REF} chr21 > ${REF_PREFIX}/chr21.fa &
#samtools faidx ${REF} chr22 > ${REF_PREFIX}/chr22.fa &
#samtools faidx ${REF} chrX > ${REF_PREFIX}/chrX.fa &
#samtools faidx ${REF} chrY > ${REF_PREFIX}/chrY.fa &
#samtools faidx ${REF} chrM > ${REF_PREFIX}/chrM.fa &
#wait

cat ${REF_PREFIX}/chr1.fa \
    ${REF_PREFIX}/chr2.fa \
    ${REF_PREFIX}/chr3.fa \
    ${REF_PREFIX}/chr4.fa \
    ${REF_PREFIX}/chr5.fa \
    ${REF_PREFIX}/chr6.fa \
    ${REF_PREFIX}/chr7.fa \
    ${REF_PREFIX}/chr8.fa \
    ${REF_PREFIX}/chr9.fa \
    ${REF_PREFIX}/chr10.fa \
    ${REF_PREFIX}/chr11.fa \
    ${REF_PREFIX}/chr12.fa \
    ${REF_PREFIX}/chr13.fa \
    ${REF_PREFIX}/chr14.fa \
    ${REF_PREFIX}/chr15.fa \
    ${REF_PREFIX}/chr16.fa \
    ${REF_PREFIX}/chr17.fa \
    ${REF_PREFIX}/chr18.fa \
    ${REF_PREFIX}/chr19.fa \
    ${REF_PREFIX}/chr20.fa \
    ${REF_PREFIX}/chr21.fa \
    ${REF_PREFIX}/chr22.fa \
    ${REF_PREFIX}/chrX.fa \
    ${REF_PREFIX}/chrM.fa >${REF_FEMALE}

bwa index ${REF_FEMALE} &
bwa index ${REF_PREFIX}/chrY.fa &
# Damn, I forgot how long it takes to build a bwa index...
wait
# 5240 seconds on my machine


END=$(date +%s.%N)
DIFF=$(echo "$END - $START" | bc)
echo ${DIFF}
exit 





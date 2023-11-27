#!/bin/bash

#COMPREHENSIVE_ANNOTATION="ref_genome/genomic.gtf"
#CHR22_ANNOTATION="ref_genome/chr22_annotation.gtf"

## Extract annotations for chromosome 22 and save to a new file
#grep -w '^NC_000022.11' $COMPREHENSIVE_ANNOTATION > $CHR22_ANNOTATION

ALIGNED_SAM="bowtie2/aligned_reads_Rep1_fastq.sam"
READS_NAME=$(basename "$ALIGNED_SAM" .sam | sed 's/aligned_reads_//')
ALIGNED_BAM="aligned_reads_$READS_NAME.bam"


# Convert SAM to BAM
mkdir -p bowtie2/simulate_tmp
samtools view -b -o "bowtie2/simulate_tmp/$ALIGNED_BAM" $ALIGNED_SAM

# Filter out unmapped reads
FILTERED_ALIGNED_BAM="filtered_$ALIGNED_BAM"
samtools view -b -F 4 -o "bowtie2/simulate_tmp/$FILTERED_ALIGNED_BAM" $ALIGNED_BAM

# Sort the BAM file
SORTED_ALIGNED_BAM="sorted_$ALIGNED_BAM"
samtools sort -o "bowtie2/simulate_tmp/$SORTED_ALIGNED_BAM" "bowtie2/simulate_tmp/$FILTERED_ALIGNED_BAM"

# Index the BAM file
samtools index "bowtie2/simulate_tmp/$SORTED_ALIGNED_BAM"

FILTERED_READS_BAM="rna_seq/chr22_$READS_NAME.bam"
FILTERED_READS_FASTQ="rna_seq/chr22_$READS_NAME.fa"

# Retrieve alignments for chromosome 22
samtools view -b -o $FILTERED_READS_BAM "bowtie2/simulate_tmp/$SORTED_ALIGNED_BAM" NC_000022.11*

# Convert BAM to FastQ
bedtools bamtofastq -i $FILTERED_READS_BAM -fq $FILTERED_READS_FASTQ



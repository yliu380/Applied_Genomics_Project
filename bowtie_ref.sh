#!/bin/bash

# Set the paths to BOWTIE2 and the reference genome FASTA file
BOWTIE2_PATH="/usr/local/bin/bowtie2"
REFERENCE_GENOME="ref_genome/hg38.fa"

# Build the BOWTIE2 index for the reference genome
echo "Building BOWTIE2 index for the reference genome..."
$BOWTIE2_PATH-build $REFERENCE_GENOME reference_index

# Set the path to the input reads (replace with your actual input file)
READS="rna_seq/Rep1_fastq.fastq"

# Set the path for the output SAM file
OUTPUT_SAM="aligned_reads.sam"

# Align reads to the reference genome using BOWTIE2
echo "Aligning reads to the reference genome..."
time $BOWTIE2_PATH -x reference_index -U $READS -S $OUTPUT_SAM

echo "Alignment completed. Output stored in $OUTPUT_SAM"

#Get alignment quality from sam file in column 5summary_bowtie_ref.txt
awk -F'\t' 'BEGIN {sum=0; count=0} {if($1 !~ /^@/){sum+=$5; count++}} END {print "Sum of MAPQ: " sum; print "Number of Mapped Reads: " count}' aligned_reads.sam >

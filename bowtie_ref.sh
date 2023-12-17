#!/bin/bash

# Check if exactly two arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <reference_genome.fna> <reads1.fastq>"
    exit 1
fi

# Set the paths to BOWTIE2 and the reference genome FASTA file
BOWTIE2_PATH="/home/xren15/mambaforge/bin/bowtie2"
REFERENCE_GENOME=$1

# Extracting the base name of the reference genome
REFERENCE_NAME=$(basename "$REFERENCE_GENOME" .fna | cut -d '_' -f 2)

# Check if the Bowtie2 index file exists
#if [ ! -e "/data/mschatz1/xren15/bowtie2/${REFERENCE_NAME}/*.1.bt2" ]; then
    # If not, build the BOWTIE2 index for the reference genome
 #   echo "/data/mschatz1/xren15/bowtie2/${REFERENCE_NAME}/*.1.bt2"
  #echo "Building BOWTIE2 index for the reference genome..."
  #mkdir -p "/data/mschatz1/xren15/bowtie2/${REFERENCE_NAME}"
  #$BOWTIE2_PATH-build $REFERENCE_GENOME "/data/mschatz1/xren15/bowtie2/${REFERENCE_NAME}/reference_index"
  #echo "Index built successfully."
#else
  #echo "Bowtie2 index already exists."
#fi

# Set the path to the input reads (replace with your actual input file)
READS=$2
READS_FILENAME=$(basename "$READS" | cut -f1 -d'.')

# Set the path for the output SAM file
OUTPUT_SAM="bowtie2/${READS_FILENAME}/aligned_reads.sam"
ALIGNMENT_SUMMARY="bowtie2/${READS_FILENAME}/alignment_summary.txt"

# Align reads to the reference genome using BOWTIE2
echo "Aligning reads to the reference genome..."
mkdir -p "bowtie2/${READS_FILENAME}"
{ time $BOWTIE2_PATH -x "/data/mschatz1/xren15/bowtie2/${REFERENCE_NAME}/reference_index" -U $READS -S $OUTPUT_SAM 2>&1 ; } | tee -a $ALIGNMENT_SUMMARY

echo "Alignment completed. Output stored in $OUTPUT_SAM. Terminal output stored in $ALIGNMENT_SUMMARY"

#Get alignment quality from sam file in column 5summary_bowtie_ref.txt
awk -F'\t' 'BEGIN {sum=0; count=0} {if($1 !~ /^@/){sum+=$5; count++}} END {print "\nSum of MAPQ: " sum; print "Number of Mapped Reads: " count}' $OUTPUT_SAM >> $ALIGNMENT_SUMMARY

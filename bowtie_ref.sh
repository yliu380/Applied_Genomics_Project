#!/bin/bash

# Set the paths to BOWTIE2 and the reference genome FASTA file
BOWTIE2_PATH="/usr/local/bin/bowtie2"
REFERENCE_GENOME="ref_genome/hg38.fa"

# Check if the Bowtie2 index file exists
if [ ! -e "reference_index.1.bt2" ]; then
  # If not, build the BOWTIE2 index for the reference genome
  echo "Building BOWTIE2 index for the reference genome..."
  $BOWTIE2_PATH-build $REFERENCE_GENOME reference_index
  echo "Index built successfully."
else
  echo "Bowtie2 index already exists."
fi

# Set the path to the input reads (replace with your actual input file)
#READS="rna_seq/Rep1_fastq.fastq"
READS="rna_seq/wgEncodeCaltechRnaSeqGm12878R1x75dFastqRep2.fastq"
READS_FILENAME=$(basename "$READS" | cut -f1 -d'.')
echo "${READS_FILENAME}"

# Set the path for the output SAM file
OUTPUT_SAM="aligned_reads_${READS_FILENAME}.sam"

# Align reads to the reference genome using BOWTIE2
echo "Aligning reads to the reference genome..."
time $BOWTIE2_PATH -x reference_index -U $READS -S $OUTPUT_SAM

echo "Alignment completed. Output stored in $OUTPUT_SAM"

ALIGNMENT_SUMMARY="alignment_summary_${READS_FILENAME}.txt"
#Get alignment quality from sam file in column 5summary_bowtie_ref.txt
awk -F'\t' 'BEGIN {sum=0; count=0} {if($1 !~ /^@/){sum+=$5; count++}} END {print "Sum of MAPQ: " sum; print "Number of Mapped Reads: " count}' $OUTPUT_SAM > $ALIGNMENT_SUMMARY

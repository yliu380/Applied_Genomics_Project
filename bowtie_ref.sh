#!/bin/bash

# Set the paths to BOWTIE2 and the reference genome FASTA file
BOWTIE2_PATH="/usr/local/bin/bowtie2"
#REFERENCE_GENOME="ref_genome/rna.fna"
REFERENCE_GENOME="ref_genome/chr22.fa"

# Check if the Bowtie2 index file exists
if [ ! -e "bowtie2/chr22/reference_index.1.bt2" ]; then
  # If not, build the BOWTIE2 index for the reference genome
  echo "Building BOWTIE2 index for the reference genome..."
  mkdir -p bowtie2/chr22
  $BOWTIE2_PATH-build $REFERENCE_GENOME bowtie2/chr22/reference_index
  echo "Index built successfully."
else
  echo "Bowtie2 index already exists."
fi

# Set the path to the input reads (replace with your actual input file)
READS="rna_seq/Rep1.fastq"
#READS="rna_seq/wgEncodeCaltechRnaSeqGm12878R1x75dFastqRep2.fastq"
READS_FILENAME=$(basename "$READS" | cut -f1 -d'.')

# Set the path for the output SAM file
OUTPUT_SAM="bowtie2/chr22/aligned_reads_${READS_FILENAME}.sam"
ALIGNMENT_SUMMARY="bowtie2/chr22/alignment_summary_${READS_FILENAME}.txt"

# Align reads to the reference genome using BOWTIE2
echo "Aligning reads to the reference genome..."
{ time $BOWTIE2_PATH -x bowtie2/chr22/reference_index -U $READS -S $OUTPUT_SAM 2>&1 ; } | tee -a $ALIGNMENT_SUMMARY

echo "Alignment completed. Output stored in $OUTPUT_SAM. Terminal output stored in $ALIGNMENT_SUMMARY"

#Get alignment quality from sam file in column 5summary_bowtie_ref.txt
awk -F'\t' 'BEGIN {sum=0; count=0} {if($1 !~ /^@/){sum+=$5; count++}} END {print "\nSum of MAPQ: " sum; print "Number of Mapped Reads: " count}' $OUTPUT_SAM >> $ALIGNMENT_SUMMARY

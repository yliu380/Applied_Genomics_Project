#!/bin/bash

# Set the paths to BOWTIE2 and the reference genome FASTA file
STAR_PATH="/Users/cindyren/mambaforge/bin/STAR"
REFERENCE_FASTA="ref_genome/GRch38.p14.fna"
REFERENCE_GTF="ref_genome/genomic.gtf"
REFERENCE_FASTA="ref_genome/chr22.fa"
REFERENCE_GTF="ref_genome/genomic.gtf"

WORKING_DIR="star/${READS_FILENAME}"

# Check if the STAR index file exists
if [ ! -e "star/Genome" ]; then
  # If not, build the STAR index for the reference genome
  echo "Building STAR index for the reference genome..."
  mkdir -p star
  mkdir -p $WORKING_DIR
  $STAR_PATH --runThreadN 8 --runMode genomeGenerate --genomeDir $WORKING_DIR --genomeFastaFiles $REFERENCE_FASTA --sjdbGTFfile $REFERENCE_GTF
  echo "Index built successfully."
else
  echo "STAR index already exists."
fi

# Set the path to the input reads (replace with your actual input file)
READS="rna_seq/Rep1.fastq"
#READS="rna_seq/wgEncodeCaltechRnaSeqGm12878R1x75dFastqRep2.fastq"
READS_FILENAME=$(basename "$READS" | cut -f1 -d'.')

# Set the path for the output SAM file
ALIGNMENT_SUMMARY="star/alignment_summary_${READS_FILENAME}.txt"
OUTPUT_PREFIX="${WORKING_DIR}${READS_FILENAME}"

# Align reads to the reference genome using STAR
echo "Aligning reads to the reference genome..."
$STAR_PATH --runThreadN 8 --readFilesIn $READS --genomeDir $WORKING_DIR --outSAMtype BAM SortedByCoordinate --outFileNamePrefix $OUTPUT_PREFIX

echo "Alignment completed. Output stored in $OUTPUT_PREFIX. Terminal output stored in $ALIGNMENT_SUMMARY"

#OUTPUT_LOG_FINAL="star/${READS_FILENAME}Log.final.out"
#FASTQC_PATH="/Users/cindyren/mambaforge/bin/fastqc"
#echo "Visualizing mapping activity using FastQC"
#$FASTQC_PATH $OUTPUT_LOG_FINAL

##Get alignment quality from sam file in column 5 summary_bowtie_ref.txt
#awk -F'\t' 'BEGIN {sum=0; count=0} {if($1 !~ /^@/){sum+=$5; count++}} END {print "\nSum of MAPQ: " sum; print "Number of Mapped Reads: " count}' $OUTPUT_SAM >> $ALIGNMENT_SUMMARY

#!/bin/bash

#SBATCH --job-name=”MyStarRefRun”
#SBATCH --output=”myLog-file”
#SBATCH --partition=defq
#SBATCH ---t 02-01:30:15
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --account=xren15
#SBATCH --cpus-per-task=6
#SBATCH --export=ALL

# Check if exactly three arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <reference_genome.fna> <reference_annotation.gtf> <reads.fastq>"
    exit 1
fi

# Set the paths to STAR and the reference genome FASTA file
STAR_PATH="/home/xren15/mambaforge/bin/STAR"
REFERENCE_FASTA=$1
REFERENCE_GTF=$2

# Set the path to the input reads (replace with your actual input file)
READS=$3
READS_FILENAME=$(basename "$READS" | cut -f1 -d'.')

<<<<<<< HEAD
WORKING_DIR="/data/mschatz1/xren15/star-hg38"
=======
WORKING_DIR="/home/data/xren15/star/${READS_FILENAME}"
STAR_TEMP_DIR="/home/data/xren15/star"
>>>>>>> 1fac91e (updated star_ref.sh)

# Check if the STAR index file exists
if [ ! -e "/data/mschatz1/xren15/star-hg38/Genome" ]; then
    # If not, build the STAR index for the reference genome
    echo entered the if
  echo "Building STAR index for the reference genome..."
  mkdir -p $WORKING_DIR
  $STAR_PATH --runThreadN 8 --runMode genomeGenerate --genomeDir $WORKING_DIR --genomeFastaFiles $REFERENCE_FASTA --sjdbGTFfile $REFERENCE_GTF
  echo "Index built successfully."
else
  echo "STAR index already exists."
fi

# Make the output directory
<<<<<<< HEAD
mkdir -p "star-hg38/${READS_FILENAME}"

# Set the path for the output SAM file
ALIGNMENT_SUMMARY="star-hg38/${READS_FILENAME}/alignment_summary.txt"
OUTPUT_PREFIX="star-hg38/${READS_FILENAME}/"

# Align reads to the reference genome using STAR
echo "Aligning reads to the reference genome..."
{ time $STAR_PATH --runThreadN 8 --readFilesIn $READS --genomeDir $WORKING_DIR --outSAMtype BAM SortedByCoordinate --outFileNamePrefix $OUTPUT_PREFIX ; } > $ALIGNMENT_SUMMARY 2>&1
=======
mkdir -p "star/${READS_FILENAME}"

# Set the path for the output SAM file
ALIGNMENT_SUMMARY="star/${READS_FILENAME}/alignment_summary.txt"
OUTPUT_PREFIX="star/${READS_FILENAME}/"

# Align reads to the reference genome using STAR
echo "Aligning reads to the reference genome..."
{ time ls -l $STAR_PATH --runThreadN 8 --readFilesIn $READS --genomeDir $WORKING_DIR --outSAMtype BAM SortedByCoordinate --outFileNamePrefix $OUTPUT_PREFIX ; } 2 > $ALIGNMENT_SUMMARY

echo "Alignment completed. Output stored in $OUTPUT_PREFIX. Terminal output stored in $ALIGNMENT_SUMMARY"

#OUTPUT_LOG_FINAL="star/${READS_FILENAME}Log.final.out"
#FASTQC_PATH="/Users/cindyren/mambaforge/bin/fastqc"
#echo "Visualizing mapping activity using FastQC"
#$FASTQC_PATH $OUTPUT_LOG_FINAL

##Get alignment quality from sam file in column 5 summary_bowtie_ref.txt
#awk -F'\t' 'BEGIN {sum=0; count=0} {if($1 !~ /^@/){sum+=$5; count++}} END {print "\nSum of MAPQ: " sum; print "Number of Mapped Reads: " count}' $OUTPUT_SAM >> $ALIGNMENT_SUMMARY

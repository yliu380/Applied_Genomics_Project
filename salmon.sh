#!/bin/bash

# Check if exactly three arguments are provided
if [ $# -ne 4 ]; then
    echo "Usage: $0 <reference_genome.fna> <annotation.gtf> <reads1.fastq> <reads2.fastq>"
    exit 1
fi

reference=$1
annotation=$2
reads1=$3
reads2=$4

gffread_path="/home/xren15/mambaforge/bin/gffread"
salmon_path="/home/xren15/mambaforge/bin/salmon"

ref_prefix=$(basename "$reference" .fna)
working_dir="/data/mschatz1/xren15/salmon/${ref_prefix}"

mkdir -p $working_dir
echo "Start processing reference genome based on annotation"
$gffread_path -w "${working_dir}/${ref_prefix}.fa" -g $reference $annotation
echo "Reference processing done. Output saved as ${working_dir}/${ref_prefix}.fa."

time $salmon_path index -t "${working_dir}/${ref_prefix}.fa" -i "${working_dir}/${ref_prefix}_index"

#if [ -z "$(ls -A $working_dir)" ]; then
  # If not, build the STAR index for the reference genome
  echo "Building Salmon index for the reference genome..."
  mkdir -p $working_dir
  time $salmon_path quant -i "${working_dir}/${ref_prefix}_index" -l A -1 $reads1 -2 $reads2 --validateMappings -o salmon/
  echo "Index built successfully."
#else
 # echo "Salmon index already exists."
#fi

echo "Start aligning reads"
mkdir -p salmon
time $salmon_path quant -i "${working_dir}/${ref_prefix}_index" -l A -1 $reads1 -2 $reads2 --validateMappings -o salmon/
echo "Reads aligned successfully. Output stored in ./salmon."

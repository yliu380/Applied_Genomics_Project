#!/bin/bash

# Check if exactly three arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <reference_genome.fna> <annotation.gtf> <reads.fastq>"
    exit 1
fi

HISAT2_PATH=""

REF_GENOME=$1
ANNOTATION=$2
READS=$3
SPLICE="$(dirname "$ANNOTATION")/splice.ss"
EXON="$(dirname "$ANNOTATION")/exon.exon"
REF_PREFIX="$(dirname "$REF_GENOME")/$(basename "$REF_GENOME" .fna)"
READS_FILENAME=$(basename "$READS" | cut -f1 -d'.')

python3 hisat2_extract_splice_sites.py $ANNOTATION > $SPLICE
python3 hisat2_extract_exons.py $ANNOTATION > $EXON

./hisat2-build --ss $SPLICE --exon $EXON $REF_GENOME $REF_PREFIX

OUTPUT_SAM="hisat/${READS_FILENAME}/aligned_reads.sam"

mkdir -p hisat/$READS_FILENAME
time ./hisat2 -x $REF_PREFIX -U $READS -S $OUPUT_SAM
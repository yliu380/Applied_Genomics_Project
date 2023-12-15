#!/bin/bash

# Check if exactly three arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <annotation.gtf> <reads.fastq>"
    exit 1
fi

ANNOTATION=$1
SPLICE="ref_genome/splice.ss"
EXON="ref_genome/exon.exon"

python3 hisat2_extract_splice_sites.py $ANNOTATION > $SPLICE
python3 hisat2_extract_exons.py $ANNOTATION > $EXON

./hisat2-build --ss /Users/aliceliu/Desktop/comp_genomics_schatz/Project/splice.ss \
               --exon /Users/aliceliu/Desktop/comp_genomics_schatz/Project/exon.exon \
               /Users/aliceliu/Desktop/comp_genomics_schatz/Project/ref_genome/merged_NA12878_maternal.fa \
               /Users/aliceliu/Desktop/comp_genomics_schatz/Project/hisat/NA12878_maternal_hisat2

time ./hisat2 -x /Users/aliceliu/Desktop/comp_genomics_schatz/Project/hisat/NA12878_maternal_hisat2 \
              -U /Users/aliceliu/Desktop/comp_genomics_schatz/Project/CaltechEncode_Gm12878_RnaSeq_Rep1.fastq \
              -S /Users/aliceliu/Desktop/comp_genomics_schatz/Project/hisat/aligned_reads_hisat2_NA12878.sam

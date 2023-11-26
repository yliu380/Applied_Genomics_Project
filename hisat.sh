#!/bin/bash

python3 hisat2_extract_splice_sites.py /Users/aliceliu/Desktop/comp_genomics_schatz/Project/gencode.v27.annotation.gtf > /Users/aliceliu/Desktop/comp_genomics_schatz/Project/splice.ss
python3 hisat2_extract_exons.py /Users/aliceliu/Desktop/comp_genomics_schatz/Project/gencode.v27.annotation.gtf > /Users/aliceliu/Desktop/comp_genomics_schatz/Project/exon.exon

./hisat2-build --ss /Users/aliceliu/Desktop/comp_genomics_schatz/Project/splice.ss \
               --exon /Users/aliceliu/Desktop/comp_genomics_schatz/Project/exon.exon \
               /Users/aliceliu/Desktop/comp_genomics_schatz/Project/ref_genome/merged_NA12878_maternal.fa \
               /Users/aliceliu/Desktop/comp_genomics_schatz/Project/hisat/NA12878_maternal_hisat2

time ./hisat2 -x /Users/aliceliu/Desktop/comp_genomics_schatz/Project/hisat/NA12878_maternal_hisat2 \
              -U /Users/aliceliu/Desktop/comp_genomics_schatz/Project/CaltechEncode_Gm12878_RnaSeq_Rep1.fastq \
              -S /Users/aliceliu/Desktop/comp_genomics_schatz/Project/hisat/aligned_reads_hisat2_NA12878.sam

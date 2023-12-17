gffread -w /data/mschatz1/yliu_proj/enc004transcripts.fa -g /data/mschatz1/yliu_proj/enc004.hap1.fa /data/mschatz1/yliu_proj/enc004_annotation

time salmon index -t enc004transcripts.fa -i enc004_salmon_index

time salmon quant -i enc004_salmon_index -l A -1 ENCFF145QCK.fastq -2 ENCFF423RWS.fastq --validateMappings -o /data/mschatz1/yliu_proj/salmon

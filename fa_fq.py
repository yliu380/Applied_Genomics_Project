def fasta_to_fastq(fasta_file, fastq_file):
    with open(fasta_file, 'r') as fasta, open(fastq_file, 'w') as fastq:
        for line in fasta:
            if line.startswith('>'):
                fastq.write(line.replace('>', '@'))
            else:
                # Fake quality
                fastq.write(line.rstrip() + '\n+\n' + 'I' * len(line.rstrip()) + '\n')

fasta_to_fastq('simulated_reads_HG19t1r1.reverse.fa', 'simulated_reads_HG19t1r1.reverse.fq')

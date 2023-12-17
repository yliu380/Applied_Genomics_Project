# Code to make comparison between actual and experimental data from simulation

def read_cig_file(file):
    true_position = {}
    with open(file, 'r') as cig_file:
        for line in cig_file:
            fields = line.strip().split('\t')
            read_id = fields[0]
            start_position = int(fields[2])
            true_position[read_id] = start_position
    return true_position

def read_sam_file(file):
    experimental_position = {}
    total_reads = 0
    with open(file, 'r') as sam_file:
        for line in sam_file:
            if not line.startswith('@'):
                total_reads += 1
                fields = line.strip().split('\t')
                read_id = fields[0]
                start_position = int(fields[3])
                experimental_position[read_id] = start_position
    return experimental_position, total_reads

def compare(cig_file, sam_file):
    true_position = read_cig_file(cig_file)
    experimental_position, total_read_sam = read_sam_file(sam_file)
    
    matched_read = 0
    total_read_cig = len(true_position)

    for read_id, true_position in true_position.items():
        if read_id in experimental_position:
            aligned_position = experimental_position[read_id]
            if aligned_position == true_position:
                matched_read += 1
    
    return matched_read, total_read_cig, total_read_sam

cig_file = 'simulated_reads_HG19t1r1.cig'
sam_file = 'bowtie.sam'

correctly_mapped_reads, total_read_cig, total_read_sam = compare(cig_file, sam_file)
print(f"Number of matched reads: {correctly_mapped_reads}")
print(f"Total reads in .cig file: {total_read_cig}")
print(f"Total reads in SAM file: {total_read_sam}")

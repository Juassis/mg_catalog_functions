from Bio import SeqIO

# Define file paths
clstr_file = "Comp.clstr"
fasta_files = ["MGnify_renamed.fasta", "EMGC_renamed.fasta"]
output_dir = "clusters/"

# Load sequences from all FASTA files into a dictionary
sequences = {}
for fasta in fasta_files:
    for record in SeqIO.parse(fasta, "fasta"):
        sequences[record.id.split(" ")[0]] = record

# Function to write sequences to file
def write_sequences_to_file(cluster_id, seq_records):
    output_file = f"{output_dir}Cluster_{cluster_id}.fasta"
    SeqIO.write(seq_records, output_file, "fasta")
    print(f"Cluster {cluster_id} written to {output_file}")

# Parse the .clstr file
current_cluster = None
cluster_sequences = []

with open(clstr_file, "r") as clstr:
    for line in clstr:
        if line.startswith(">Cluster"):
            # Save the current cluster's sequences
            if current_cluster is not None:
                write_sequences_to_file(current_cluster, cluster_sequences)
            # Start a new cluster
            current_cluster = line.strip().split(" ")[1]
            cluster_sequences = []
        else:
            # Extract sequence ID from the line
            seq_id = line.split(">")[1].split("...")[0]
            if seq_id in sequences:
                cluster_sequences.append(sequences[seq_id])

# Write the last cluster
if current_cluster is not None:
    write_sequences_to_file(current_cluster, cluster_sequences)


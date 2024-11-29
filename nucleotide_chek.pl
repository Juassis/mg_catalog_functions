#!/usr/bin/env perl
# count Start and Stop Codons in nucleotides sequence
#
use strict;
use warnings;
use Bio::SeqIO;

# Input file and output TSV file
my ($f1) = @ARGV;
my $tsv_out = "$f1.codon_stats.tsv";

# Create SeqIO objects for input and output
my $in = Bio::SeqIO->new(-file => "<$f1");
my $out = Bio::SeqIO->new(-file => ">$f1.INTERNAL_STOPS.fa", -format => "fasta");

# Open the TSV output file for writing
open(my $tsv_fh, '>', $tsv_out) or die "Could not open file '$tsv_out' $!";

# Write the header to the TSV file
print $tsv_fh join("\t", qw/ID FirstAA Length StartCheck StopCheck InternalStops/) . "\n";

# Process each sequence
while (my $s = $in->next_seq) {
    my $id = $s->primary_id;
    my $alpha = $s->alphabet;
    my $aa = $s->seq;

    # Check for start and stop codons
    my $start = ($aa =~ /^ATG/) ? '1' : '0';
    my $end = ($aa =~ /TAA$|TAG$|TGA$/) ? '1' : '0';

    # Remove the first and last characters from the sequence (start and stop codons)
    $aa =~ s/^.{1}//;
    $aa =~ s/.{1}$//;

    # Count internal stop codons
    my @stops = ($aa =~ /(\.|\*)/g);
    my $stop = scalar @stops;

    # Write results to the TSV file
    print $tsv_fh join("\t", $id, $alpha || '.', length($aa), $start, $end, $stop || '0') . "\n";

    # Write sequences with internal stop codons to the output FASTA file
    $out->write_seq($s) if $stop;
}

# Close the TSV file
close($tsv_fh);

# Print completion message
print "Results written to $tsv_out\n";


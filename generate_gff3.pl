#!/usr/bin/perl
use strict;
use warnings;

# Read the input in SAM format
# E.g. 
# samtools view tiles_remap_sorted.bam | ./generate_gff.pl

my %gff;
my @unsorted = (); # array where the hits will be stored as hash refs

#output gff3 header
print "##gff-version 3\n";

my $serial = 0;
while  ( <> ) 
{
	$serial++;
	my $line = $_;
    chomp( $line );
	#print "$line\n";
	my @fields = split("\t" , $line);


	my ($src_chr, $src_range) = split(":", $fields[0]);
	$src_chr =~ s/^chr//i;

	my ($src_start, $src_end) = split("-", $src_range);

	my $src_pos = ($src_start + $src_end) / 2;

	my $target_chr = $fields[2];
	$target_chr =~ s/^chr//i;
	my $target_start = $fields[3];

	next unless ( defined $fields[13] );

	#TODO: figure out the correct mapping length from the CIAGR string
	my $target_length = 151.0;
	my $target_end = $target_start + $target_length;
	my ($as, $i, $alignment_score) = split(":", $fields[13]);

	next unless ( defined $alignment_score);
	next if ( $alignment_score < 100);

	my $score = $alignment_score / $target_length;

	# Make sure we don't pick up self identities
	next if ( ($src_chr =~ m/^$target_chr$/) && ($src_start == $target_start || $src_end == $target_end ));

	# Output in gff3 format
	my $output_line = "Chr$src_chr\tbwa\tidentity\t$src_pos\t$src_pos\t$score\t.\t.\tname=identity;bwa_hit=Chr$target_chr:$target_start..$target_end;AS=$alignment_score";
	push @unsorted, { 'pos' => $src_pos, 'line' => $output_line, 'alignment_score' => $alignment_score};

}


# sort by position and then alignment_score desc
my @sorted = sort { $a->{'pos'} <=> $b->{'pos'} || $b->{'alignment_score'} <=> $a->{'alignment_score'}} @unsorted;
#print join "\n", map {$_->{'line'}} @sorted;

my $pos_old = 0;
foreach my $hit (@sorted)
{
	my $pos_new = $hit->{'pos'};

	# Avoid duplicates. Only report one of the highest scoring hits for each pos
	if ($pos_old < $pos_new) 
	{
		my $line_new = $hit->{'line'};
		print $line_new ."\n";
	}
	$pos_old = $pos_new;
}


exit;






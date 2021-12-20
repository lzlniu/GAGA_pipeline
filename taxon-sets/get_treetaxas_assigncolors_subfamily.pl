#!/bin/perl
use strict;
use warnings;


my ($line, $name);


my $gagaidlist = "/home/projects/ku_00039/people/zelili/GAGA/taxon-sets/GAGA_species_list.txt";

# Read species list and prefix
my %shortname;
my %subfamily;
open(Gagafile, "<", $gagaidlist);
while(<Gagafile>){
	chomp;
	$line = $_;
	next if ($line !~ /\S+/);
	$line =~ s/\n//g; $line =~ s/\r//g;
	my @subl = split (/\t/, $line);
	$shortname{$subl[0]} = $subl[4];
	$subfamily{$subl[0]} = $subl[2];
}
close Gagafile;


open (ResultsBranch, ">", "$ARGV[0]_colors_styles_branches.txt");
open (ResultsLabel, ">", "$ARGV[0]_colors_styles_labels.txt");
open (ResultsRename, ">", "$ARGV[0]_rename_labels.txt");

print ResultsBranch "TREE_COLORS

SEPARATOR TAB

DATA\n";

print ResultsLabel "TREE_COLORS

SEPARATOR TAB

DATA\n"; 

print ResultsRename "LABELS

SEPARATOR TAB

DATA\n"; 


open (File, "<", $ARGV[0]);
while (<File>) {
	chomp;
	$line = $_;
	next if ($line !~ /\S+/);
	my @subline = split (/\(|,|\)/, $line);
	foreach my $field (@subline){
#		if ($field =~ /(GAGA-\d\d\d\d)(\w+):/ || $field =~ /(NCBI-\d\d\d\d)(\w+):/ || $field =~ /(OUT-\d\d\d\d)(\w+):/){
		if ($field =~ /(GAGA-\d\d\d\d)/ || $field =~ /(NCBI-\d\d\d\d)/ || $field =~ /(OUT-\d\d\d\d)/){
			my $gagaid = $1;
			#my $idname = $2;
			my $fullname = "$1";

			unless (exists $shortname{$gagaid}){
				print "Cannot find species name for $gagaid\n";
			}
			unless (exists $subfamily{$gagaid}){
				print "Cannot find subfamily for $gagaid\n";
			}			

			my $cname = $shortname{$gagaid};
			my $subf = $subfamily{$gagaid};

			if ($subf =~ /Leptanillinae/){ # Green
				print ResultsBranch "$fullname\tbranch\t#04aa08\tnormal\n";
				print ResultsLabel "$fullname\tlabel\t#04aa08\n";

			} elsif ($subf =~ /Paraponerinae/){ # Dark blue
				print ResultsBranch "$fullname\tbranch\t#020bf3\tnormal\n";
				print ResultsLabel "$fullname\tlabel\t#020bf3\n";

			} elsif ($subf =~ /Amblyoponinae/){ # Orange
				print ResultsBranch "$fullname\tbranch\t#e77a01\tnormal\n";
				print ResultsLabel "$fullname\tlabel\t#e77a01\n";

			} elsif ($subf =~ /Proceratiinae/){ # Dark red
				print ResultsBranch "$fullname\tbranch\t#c80a0a\tnormal\n";
				print ResultsLabel "$fullname\tlabel\t#c80a0a\n";

			} elsif ($subf =~ /Ponerinae/){ # Light blue
				print ResultsBranch "$fullname\tbranch\t#1cc2c4\tnormal\n";
				print ResultsLabel "$fullname\tlabel\t#1cc2c4\n";

			} elsif ($subf =~ /Dorylinae/){ # Light green
				print ResultsBranch "$fullname\tbranch\t#60c304\tnormal\n";
				print ResultsLabel "$fullname\tlabel\t#60c304\n";
 
			} elsif ($subf =~ /Dolichoderinae/){ # Purple
				print ResultsBranch "$fullname\tbranch\t#4505d4\tnormal\n";
				print ResultsLabel "$fullname\tlabel\t#4505d4\n";

			} elsif ($subf =~ /Myrmeciinae/){ # Brown-Yellow
				print ResultsBranch "$fullname\tbranch\t#d2ae04\tnormal\n";
				print ResultsLabel "$fullname\tlabel\t#d2ae04\n";

			} elsif ($subf =~ /Pseudomyrmecinae/){ # Dark green
				print ResultsBranch "$fullname\tbranch\t#03783f\tnormal\n";
				print ResultsLabel "$fullname\tlabel\t#03783f\n";

			} elsif ($subf =~ /Formicinae/){ # Brown
				print ResultsBranch "$fullname\tbranch\t#6d3c12\tnormal\n";
				print ResultsLabel "$fullname\tlabel\t#6d3c12\n";

			} elsif ($subf =~ /Ectatomminae/){ # Red
				print ResultsBranch "$fullname\tbranch\t#f41e23\tnormal\n";
				print ResultsLabel "$fullname\tlabel\t#f41e23\n";

			} elsif ($subf =~ /Myrmicinae/){ # Blue
				print ResultsBranch "$fullname\tbranch\t#069ffe\tnormal\n";
				print ResultsLabel "$fullname\tlabel\t#069ffe\n";

			} elsif ($subf =~ /Outgroup/){ # Black
				print ResultsBranch "$fullname\tbranch\t#000000\tnormal\n";
				print ResultsLabel "$fullname\tlabel\t#000000\n";
			}

			print ResultsRename "$fullname\t$gagaid\_$cname\n";


		}
	
	}
}
close File;
#close Results;


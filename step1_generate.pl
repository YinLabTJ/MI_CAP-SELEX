use strict;
my $seq_file_dir=shift;
`mkdir -p spacek40_out`;
open OUT,">step1_spacek40_sample.sh";
`mkdir -p spacek40_out/6mer`;
`mkdir -p spacek40_out/8mer`;
open IN,"single.list";
while(<IN>){
	chomp;
	my @t=split;
	print OUT "spacek40 -40N -nogaps $seq_file_dir/$t[1]0u_sig.seq $seq_file_dir/$t[1]$t[2]$t[3]_sig.seq 6 6 1 > spacek40_out/6mer/$t[0].out\n";
	print OUT "spacek40 -40N -nogaps $seq_file_dir/$t[1]0u_sig.seq $seq_file_dir/$t[1]$t[2]$t[3]_sig.seq 8 8 1 > spacek40_out/8mer/$t[0].out\n";
}
close IN;
close OUT;
open OUT,">step1_spacek40_pair.sh";
open IN,"pair.list";
while(<IN>){
	chomp;
	my @t=split;
	print OUT "spacek40 -40N -nogaps $seq_file_dir/$t[1]0u_sig.seq $seq_file_dir/$t[1]$t[2]3u_sig.seq 6 6 1 > spacek40_out/6mer/$t[0].$t[1].out\n";
	print OUT "spacek40 -40N -nogaps $seq_file_dir/$t[1]0u_sig.seq $seq_file_dir/$t[1]$t[2]3u_sig.seq 8 8 1 > spacek40_out/8mer/$t[0].$t[1].out\n";
}
close IN;
close OUT;

#!/usr/bin/perl
#Running spacek40
use strict;
use File::Spec;

die "Usage: perl step1_spacek40.pl batch_file seq_file_dir\n" unless(@ARGV==2);
my $batch_file=shift; my $seq_file_dir=shift;

my $cwd=File::Spec->rel2abs(__FILE__);
my ($vol,$dir,$file)=File::Spec->splitpath($cwd);

die "Individual TF Batch file missing\n" unless(-e "$dir/../data/Curated_Prey_Final.txt");
open IN,"$dir/../data/Curated_Prey_Final.txt";
<IN>;
my %barcode; my %barcodes; my %ind_tf;
while(<IN>){
	chomp;
	my @t=split /\t/,$_;
	if($t[0]=~/_/){
		my @t2=split /_/,$t[0];
		$barcode{$t2[0]}=$t[1]."\t".$t[2]."\t".$t[3];
		$barcode{$t2[1]}=$t[4]."\t".$t[5]."\t".$t[6];
	}else{
		$barcode{$t[0]}=$t[1]."\t".$t[2]."\t".$t[3];
	}
}
close IN;
open IN,"$batch_file";
<IN>;
while(<IN>){
	chomp;
	my @t=split;
	next unless($t[0]=~/_/);
	my $pair=$t[0];
	my @t2=split /_/,$t[0];
	$barcodes{$pair}.="," if(defined($barcodes{$pair}));
	$barcodes{$pair}.=$t[2]."\t".$t[3];
	$ind_tf{$t2[0]}=1;
	$ind_tf{$t2[1]}=1;
}
close IN;

`mkdir -p spacek40_out`;
`mkdir -p spacek40_out/6mer`;
`mkdir -p spacek40_out/8mer`;
open OUT,">spacek40_out/step1_spacek40.sh";
foreach my $key(sort keys %barcode){
	if(defined($ind_tf{$key})){
		my @t=split /\t/,$barcode{$key};
		print OUT "spacek40 -40N -nogaps $seq_file_dir/$t[0]0u_sig.seq $seq_file_dir/$t[0]$t[1]$t[2]_sig.seq 6 6 1 > spacek40_out/6mer/$key.out\n";
		print OUT "spacek40 -40N -nogaps $seq_file_dir/$t[0]0u_sig.seq $seq_file_dir/$t[0]$t[1]$t[2]_sig.seq 8 8 1 > spacek40_out/8mer/$key.out\n";
	}
}
foreach my $key(sort keys %barcodes){
	my @tf=split /,/,$barcodes{$key};
	foreach my $tf(@tf){
		my @t=split /\t/,$barcodes{$key};
		print OUT "spacek40 -40N -nogaps $seq_file_dir/$t[0]0u_sig.seq $seq_file_dir/$t[0]$t[1]3u_sig.seq 6 6 1 > spacek40_out/6mer/$key.$t[0].out\n";
		print OUT "spacek40 -40N -nogaps $seq_file_dir/$t[0]0u_sig.seq $seq_file_dir/$t[0]$t[1]3u_sig.seq 8 8 1 > spacek40_out/8mer/$key.$t[0].out\n";
	}
}
close OUT;


`bash spacek40_out/step1_spacek40.sh`;
`rm spacek40_out/step1_spacek40.sh`;

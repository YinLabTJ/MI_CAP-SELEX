#!/usr/bin/perl
#Filter spacek40 output
use strict;

die "Usage: perl step1_spacek40.pl batch_file\n" unless(@ARGV==1);
my $batch_file=shift;
my %tf_pairs; my %file_list;

open IN,"$batch_file";
open OUT,">spacek40_out/local_max_top.sh";
while(<IN>){
	my @t=split;
	next unless($t[0]=~/_/);
	$tf_pairs{$t[0]}=1;
	my @ind_tf=split /_/,$t[0];
	if(-e "spacek40_out/6mer/$ind_tf[0].out" && -e "spacek40_out/6mer/$ind_tf[1].out"){
		print OUT "grep local spacek40_out/6mer/$ind_tf[0].out | cut -f6,12 | awk '{if(\$2>1) print \$0}' |sort -k2,2rn | head -100 > spacek40_out/6mer/$ind_tf[0].tmp\n";
		print OUT "grep local spacek40_out/6mer/$ind_tf[1].out | cut -f6,12 | awk '{if(\$2>1) print \$0}' |sort -k2,2rn | head -100 > spacek40_out/6mer/$ind_tf[1].tmp\n";
		print OUT "grep local spacek40_out/6mer/$t[0].$t[2].out | cut -f6,12 | awk '{if(\$2>1) print \$0}' |sort -k2,2rn | head -100 > spacek40_out/6mer/$t[0].$t[2].tmp\n";
		print OUT "grep local spacek40_out/8mer/$ind_tf[0].out | cut -f6,12 | awk '{if(\$2>1) print \$0}' |sort -k2,2rn | head -100 > spacek40_out/8mer/$ind_tf[0].tmp\n";
		print OUT "grep local spacek40_out/8mer/$ind_tf[1].out | cut -f6,12 | awk '{if(\$2>1) print \$0}' |sort -k2,2rn | head -100 > spacek40_out/8mer/$ind_tf[1].tmp\n";
		print OUT "grep local spacek40_out/8mer/$t[0].$t[2].out | cut -f6,12 | awk '{if(\$2>1) print \$0}' |sort -k2,2rn | head -100 > spacek40_out/8mer/$t[0].$t[2].tmp\n";
		$file_list{$ind_tf[0]}=1;
		$file_list{$ind_tf[1]}=1;
		$file_list{"$t[0].$t[2]"}=1;
	}
}
close IN; close OUT;

`bash spacek40_out/local_max_top.sh`;
`rm spacek40_out/local_max_top.sh`;
my @kmer=qw/6mer 8mer/;
foreach my $key(sort keys %file_list){
	foreach my $kmer(@kmer){
		my %fc=();
		open IN,"spacek40_out/$kmer/$key.tmp";
		while(<IN>){
			chomp;
			my @t=split;
			my $seq=$t[0];
			my $rev=reverse($seq);
			$rev=~tr/[ATCG]/[TAGC]/;
			$seq=$rev if($seq gt $rev);
			$fc{$seq}=$t[1];
		}
		open OUT,">spacek40_out/$kmer/$key.tmp2";
		foreach my $key(sort keys %fc){
			print OUT "$key\t$fc{$key}\n";
		}
		`sort -k2,2rn spacek40_out/$kmer/$key.tmp2 > spacek40_out/$kmer/$key.candidate`;
		`rm spacek40_out/$kmer/$key.tmp`;
		`rm spacek40_out/$kmer/$key.tmp2`;
		close OUT;
	}
}

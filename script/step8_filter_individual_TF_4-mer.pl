use strict;
use File::Spec;

my $cwd=File::Spec->rel2abs(__FILE__);
my ($vol,$shdir,$file)=File::Spec->splitpath($cwd);

my $batch_file=shift;
my $seq_file_dir=shift;

my %top5p_in_five;
open IN,"output/top5p_sort.xls";
while(<IN>){
	chomp;
	my @t=split;
	last if($t[2]>5);
	$top5p_in_five{$t[1]}=1; #the top 5% MI signals were concentrated to no more than spacings and orientations.
}
close IN;

open IN,"output/filter_list";
open OUT,">output/step8_top5p_no_more_than_5_spacing.sh";
open OUT2,">output/step8_top5p_no_more_than_5_spacing.shift.sh";
while(<IN>){
	chomp;
	my @t=split;
	next unless(defined($top5p_in_five{$t[1]}));
	my $pair_8mer=$t[2]."_".$t[3];
	my @s=split /,/,$t[6];
	$s[0]=~s/_//g;
	$s[1]=~s/_//g;
	$s[2]=~s/_//g;
	my @t1=split /,/,$t[2];
	my @t2=split /,/,$t[3];
	foreach my $t1(@t1){
		foreach my $t2(@t2){
			my $pairbarcode=$t[0].":".$t[1];
			print OUT "perl $shdir/step8_rm_individual_TF_4-mer_iteration.pl $seq_file_dir/$s[0]3u_sig.seq $seq_file_dir/$s[1]_sig.seq $seq_file_dir/$s[2]_sig.seq tf1 tf2 $t1\_$t2 $pairbarcode $pair_8mer 8 4 output/$t[0]_$s[0] $batch_file\n";
			print OUT2 "perl $shdir/step8_rm_individual_TF_4-mer_iteration_shift.pl $seq_file_dir/$s[0]3u_sig.seq $seq_file_dir/$s[1]_sig.seq $seq_file_dir/$s[2]_sig.seq tf1 tf2 $t1\_$t2 $pairbarcode $pair_8mer 7 4 output/$t[0]_$s[0] $batch_file\n";
		}
	}
}
close IN;
close OUT; close OUT2;

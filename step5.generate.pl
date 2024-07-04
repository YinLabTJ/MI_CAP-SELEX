use strict;
use Cwd;
my $dir=cwd;

my $seq_file_dir=shift;

my $datestring = localtime();
print "start at $datestring\n";

`mkdir -p $dir/single_kmer_pair_out`;

open IN,"filter.8mer.xls";
`mkdir -p output`;
open OUT1,">output/work.sh";
while(<IN>){
	chomp;
	my @t=split;
	if(@t<8){
		my @t1=split /_/,$t[0];
		my @t2=split /,/,$t[6];
		$t2[0]=~s/_//g; $t2[1]=~s/_//g; $t2[2]=~s/_//g;
		my $seqfile="$seq_file_dir/$t2[0]3u_sig.seq";
		my $tf1="$seq_file_dir/$t2[1]\_sig.seq";
		my $tf2="$seq_file_dir/$t2[2]\_sig.seq";
		`mkdir -p $dir/output/$t[0]\_$t[1]\_$t2[0]`;
		`mkdir -p $dir/output/Huddinge/$t[0]\_$t[1]\_$t2[0]`;
		`mkdir -p $dir/output/Huddinge_final`;
		`perl $dir/step5_compute_4in8.pl $seqfile $dir/output/$t[0]\_$t[1]\_$t2[0] t1t2`;
		`perl $dir/step5_compute_4in8.pl $tf1 $dir/output/$t[0]\_$t[1]\_$t2[0] t1`;
		`perl $dir/step5_compute_4in8.pl $tf2 $dir/output/$t[0]\_$t[1]\_$t2[0] t2`;

		
		my @t81=split /,/,$t[2];
		my @t82=split /,/,$t[3];
		print "$t[0] Start\n";
		my $svg8; my $svg7;
		foreach my $t81(@t81){
			foreach my $t82(@t82){
				print OUT1 "perl $dir/step6_count.pl $seqfile $t81\_$t82 $t[0] $t[2]\_$t[3] 8 4 $dir/output/$t[0]\_$t[1]\_$t2[0] t1t2 > $dir/output/Huddinge/$t[0]\_$t[1]\_$t2[0]/$t81\_$t82.svg\n";
				print OUT1 "perl $dir/step6_count.pl $tf1 $t81\_$t82 $t[0] $t[2]\_$t[3] 8 4 $dir/output/$t[0]\_$t[1]\_$t2[0] t1 > $dir/output/Huddinge/$t[0]\_$t[1]\_$t2[0]/$t81\_$t82.t1.svg\n";
				print OUT1 "perl $dir/step6_count.pl $tf2 $t81\_$t82 $t[0] $t[2]\_$t[3] 8 4 $dir/output/$t[0]\_$t[1]\_$t2[0] t2 > $dir/output/Huddinge/$t[0]\_$t[1]\_$t2[0]/$t81\_$t82.t2.svg\n";
				print OUT1 "convert $dir/output/Huddinge/$t[0]\_$t[1]\_$t2[0]/$t81\_$t82.svg Huddinge/$t[0]\_$t[1]\_$t2[0]/$t81\_$t82.png\n";
				
				$svg8.="," if($svg8=~/svg/);
				$svg8.="Huddinge/$t[0]\_$t[1]\_$t2[0]/$t81\_$t82.svg";

				print OUT1 "perl $dir/step6_count_further.pl $seqfile $t81\_$t82 $t[0] $t[2]\_$t[3] 7 4 $dir/output/$t[0]\_$t[1]\_$t2[0] t1t2 > $dir/output/Huddinge/$t[0]\_$t[1]\_$t2[0]/$t81\_$t82.further.svg\n";
				print OUT1 "perl $dir/step6_count_further.pl $tf1 $t81\_$t82 $t[0] $t[2]\_$t[3] 7 4 $dir/output/$t[0]\_$t[1]\_$t2[0] t1> $dir/output/Huddinge/$t[0]\_$t[1]\_$t2[0]/$t81\_$t82.further.t1.svg\n";
				print OUT1 "perl $dir/step6_count_further.pl $tf2 $t81\_$t82 $t[0] $t[2]\_$t[3] 7 4 $dir/output/$t[0]\_$t[1]\_$t2[0] t2> $dir/output/Huddinge/$t[0]\_$t[1]\_$t2[0]/$t81\_$t82.further.t2.svg\n";
				print OUT1 "perl $dir/step7_rm_single.pl $dir/output/$t[0]\_$t[1]\_$t2[0]/MI.$t[0].$t81\_$t82.t1t2.further.xls $dir/output/$t[0]\_$t[1]\_$t2[0]/MI.$t[0].$t81\_$t82.t1.further.xls $dir/output/$t[0]\_$t[1]\_$t2[0]/MI.$t[0].$t81\_$t82.t2.further.xls $t81\_$t82 $t[0] $t[2]\_$t[3] 7 4 $dir/output/$t[0]\_$t[1]\_$t2[0] $dir/output/$t[0]\_$t[1]\_$t2[0]/MI.$t[0].$t81\_$t82.t1t2-t1-t2.further.xls > Huddinge/$t[0]\_$t[1]\_$t2[0]/$t81\_$t82.t1t2-t1-t2.further.svg\n";
				print OUT1 "convert $dir/output/Huddinge/$t[0]\_$t[1]\_$t2[0]/$t81\_$t82.further.svg $dir/output/Huddinge/$t[0]\_$t[1]\_$t2[0]/$t81\_$t82.further.png\n";
				print OUT1 "convert $dir/output/Huddinge/$t[0]\_$t[1]\_$t2[0]/$t81\_$t82.t1t2-t1-t2.further.svg $dir/output/Huddinge/$t[0]\_$t[1]\_$t2[0]/$t81\_$t82.t1t2-t1-t2.further.png\n";
				
				$svg7.="," if($svg7=~/svg/);
				$svg7.="$dir/output/Huddinge/$t[0]\_$t[1]\_$t2[0]/$t81\_$t82.further.svg";
			}
		}
		print OUT1 "perl $dir/step8_svg_merge.pl $svg7 $dir/output/Huddinge_final/$t2[0].further.svg\n";
		print OUT1 "perl $dir/step8_svg_merge.pl $svg8 $dir/output/Huddinge_final/$t2[0].svg\n";
		print "$t[0] End\n";
	}
}
close IN;
close OUT1; close OUT2;
$datestring = localtime();
print "finish at $datestring\n";

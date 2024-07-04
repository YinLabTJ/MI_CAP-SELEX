use strict;
open IN,"pair.list";
open OUT,">step2.sh";
while(<IN>){
	chomp;
	my @t=split;
	my @t2=split /_/,$t[0];
	print OUT "mkdir -p pair_tmp_6mer/$t[0]\n";
	if(-e "spacek40_out/6mer/$t2[0].out" && -e "spacek40_out/6mer/$t2[1].out"){
		print OUT "grep local spacek40_out/6mer/$t2[0].out | cut -f6,12 | awk '{if(\$2>1) print \$0}' |sort -k2,2rn | head -100 > pair_tmp_6mer/$t[0]/$t2[0].candidate\n";
		print OUT "grep local spacek40_out/6mer/$t2[1].out | cut -f6,12 | awk '{if(\$2>1) print \$0}' |sort -k2,2rn | head -100 > pair_tmp_6mer/$t[0]/$t2[1].candidate\n";
		print OUT "grep local spacek40_out/6mer/$t[0].$t[1].out | cut -f6,12 | awk '{if(\$2>1) print \$0}' |sort -k2,2rn | head -100 > pair_tmp_6mer/$t[0]/$t[0].$t[1].candidate\n";

		print OUT "perl step2_filter_reverse_dup.pl pair_tmp_6mer/$t[0]/$t[0].$t[1]\n";
		print OUT "perl step2_filter_reverse_dup.pl pair_tmp_6mer/$t[0]/$t2[0]\n";
		print OUT "perl step2_filter_reverse_dup.pl pair_tmp_6mer/$t[0]/$t2[1]\n";
	}
	print OUT "mkdir -p pair_tmp_8mer/$t[0]\n";
	if(-e "spacek40_out/8mer/$t2[0].out" && -e "spacek40_out/8mer/$t2[1].out"){
		print OUT "grep local spacek40_out/8mer/$t2[0].out | cut -f6,12 | awk '{if(\$2>1) print \$0}' |sort -k2,2rn | head -100 > pair_tmp_8mer/$t[0]/$t2[0].candidate\n";
		print OUT "grep local spacek40_out/8mer/$t2[1].out | cut -f6,12 | awk '{if(\$2>1) print \$0}' |sort -k2,2rn | head -100 > pair_tmp_8mer/$t[0]/$t2[1].candidate\n";
		print OUT "grep local spacek40_out/8mer/$t[0].$t[1].out | cut -f6,12 | awk '{if(\$2>1) print \$0}' |sort -k2,2rn | head -100 > pair_tmp_8mer/$t[0]/$t[0].$t[1].candidate\n";

		print OUT "perl step2_filter_reverse_dup.pl pair_tmp_8mer/$t[0]/$t[0].$t[1]\n";
		print OUT "perl step2_filter_reverse_dup.pl pair_tmp_8mer/$t[0]/$t2[0]\n";
		print OUT "perl step2_filter_reverse_dup.pl pair_tmp_8mer/$t[0]/$t2[1]\n";
	}
}
close IN; close OUT;

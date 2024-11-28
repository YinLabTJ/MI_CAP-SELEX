#!/usr/bin/perl
$wc=`wc -l x.forR.xls`;
@t=split /\t/,$wc;
exit if($t[0]==0);
open IN,"x.forR.xls";
open ANO,">anova.forR.xls";
while(<IN>){
	chomp;
	@t=split;
	$tmp=shift(@t);
	#print "$avr\n";
	$mid=int(@t/2);
	$start=$mid-4; $end=$mid+5;
	next if(@t<10);
	for($i=$start;$i<=$end;$i++){
		print ANO "$tmp\t$i\t$t[$i-1]\n";
	}
}
close IN;
close ANO;

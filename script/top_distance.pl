#!/usr/bin/perl
$wc=`wc -l MI.tmp2.xls`;
@t=split /\s/,$wc;
$total=$t[0];
open IN,"MI.tmp2.xls";
$win=1;
$group=0; $n=0;
while(<IN>){
	chomp;
	$n++;
	@t=split;
	if(!defined($hash{$t[0]})){
		$group++;
		$hash{$t[0]}=1;
	}
	if($n>$total/20*$win && $t[1]!=$last){
		$per=$win*5;
		print "$per\t$group\n";
		$win++;
	}
	$last=$t[1];
}
close IN;
if($win>1){
	print "100\t$group\n" unless($per==100);
}

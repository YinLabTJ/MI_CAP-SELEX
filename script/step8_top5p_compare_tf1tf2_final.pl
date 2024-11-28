#!/usr/bin/perl
$MI1=shift; $out_file=shift; $lkmer=shift; $s1dir=shift;

open MI,"$MI1"; open OUT,">$s1dir/tmp1.$lkmer";
<MI>;
while(<MI>){
	@m=split;
	$j=$m[0];
	for($i=1;$i<@m;$i++){
		$mi1{$i}{$j}=$m[$i];
		$dis=$j-$i;
		print OUT "$m[$i]\t$dis\t$i\t$j\n";
	}
}
close MI;
close OUT;

`sort -k1,1rg $s1dir/tmp1.$lkmer | head -29 > $s1dir/t1t2.top5.xls`;
`rm $s1dir/tmp1.$lkmer`;

open IN,"$s1dir/t1t2.top5.xls";
while(<IN>){
	chomp;
	@t=split;
	$dis_num{$t[1]}++;
}
close IN;

$dis_n=0;
foreach $key(keys %dis_num){
	$dis_n++;
}

open OUT,">$out_file";
print OUT "$dis_n\n";
close OUT;


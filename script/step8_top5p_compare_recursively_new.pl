$MI1=shift; $MI2=shift; $distance_file=shift; $check_file=shift; $lkmer=shift; $s1dir=shift;
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
open MI,"$MI2"; open OUT,">$s1dir/tmp1.$lkmer";
<MI>;
while(<MI>){
	@m=split;
	$j=$m[0];
	for($i=1;$i<@m;$i++){
		$mi2{$i}{$j}=$m[$i];
		$dis=$j-$i;
		print OUT "$m[$i]\t$dis\t$i\t$j\n";
	}
}
close MI;
close OUT;
`sort -k1,1rg $s1dir/tmp1.$lkmer | head -29 > $s1dir/t1.top5.xls`;
`rm $s1dir/tmp1.$lkmer`;

open IN,"$s1dir/t1t2.top5.xls";
while(<IN>){
	chomp;
	@t=split;
	next if($t[0]<0);
	$dis_num{$t[1]}++; 
	$t1t2_max=$dis_num{$t[1]} if($t1t2_max<$dis_num{$t[1]});
}
close IN;

$t1_max=0;
open IN,"$s1dir/t1.top5.xls";
while(<IN>){
	chomp;
	@t=split;
	next if($t[0]<0);
	$dis_num_t1{$t[1]}++;
	$t1_max=$dis_num_t1{$t[1]} if($t1_max<$dis_num_t1{$t[1]});
	$t1_dis{$t[1]}=1;
}
close IN;

$t1_dis_num=0;
foreach $key(keys %dis_num){
	$t1t2_dis_num++;
}
foreach $key(keys %t1_dis){
	$t1_dis_num++;
}
$conclusion=0;

open OUT,">$distance_file";
foreach $key(keys %dis_num){
	$per=$dis_num_t1{$key}/$dis_num{$key};
	$per=1 if($per>1);
	$hash{$key}=$per;
	if($per>=0.5 && $dis_num{$key}>=3){
		$conclusion=1;
		$num_check++;
		print OUT "," if($num_check>1);
		print OUT "$key";
	}
}
close OUT;
if($t1t2_dis_num>=5 && $conclusion==1 && $t1t2_max<15){
	$conclusion=4;
}
if($t1_dis_num>=5 && $conclusion==1 && $t1_max<15){
	$conclusion=3;
}
open OUT,">$check_file";
print OUT "$conclusion\n";
foreach $key(keys %hash){
	print OUT "$key\t$hash{$key}\t$dis_num_t1{$key}/$dis_num{$key}\n";
}
close OUT;



$dir=shift; $infile=shift; $already_filter=shift;
open IN,"$infile";
while(<IN>){
	chomp;
	@t=split;
	@s=split /_/,$t[0];
	$spacing=$s[3]-$s[1];
	$key=$t[1].":".$spacing;
	$total{$key}+=$t[2];
	$num{$key}++;
}
close IN;
open TMP,">$dir/step8.tmp";
foreach $key(keys %total){
	$average=$total{$key}/$num{$key};
	print TMP "$key\t$average\n";
}
close TMP;
`sort -k2,2rg $dir/step8.tmp > $dir/step8.sort`;
open IN,"$already_filter";
while(<IN>){
	chomp;
	@t=split;
	$key=$t[1].":".$t[0];
	$a_f{$key}=1;
}
close IN;
open IN,"$dir/step8.sort"; open OUT,">$dir/step8.add";
while(<IN>){
	chomp;
	@t=split;
	if(defined($a_f{$t[0]})){
		next;
	}else{
		@t2=split /:/,$t[0];
		print OUT "$t2[1]\t$t2[0]\t$t[1]\n";
		close OUT;
		`cat $dir/step8.add >> $already_filter`;
		last;
	}
}
close IN; close OUT;
`rm $dir/step8.tmp $dir/step8.sort $dir/step8.add`;

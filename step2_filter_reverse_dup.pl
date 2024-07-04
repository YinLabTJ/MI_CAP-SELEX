use strict;
my $sample=shift;
open IN,"$sample.candidate";
open OUT,">tmp";
my %fc;
while(<IN>){
	chomp;
	my @t=split;
	my $seq=$t[0];
	my $rev=reverse($seq);
        $rev=~tr/[ATCG]/[TAGC]/;
        $seq=$rev if($seq gt $rev);
	$fc{$seq}=$t[1];
}
close IN;
my $key;
foreach $key(sort keys %fc){
	print OUT "$key\t$fc{$key}\n";
}
close OUT;
`sort -k2,2rn tmp > $sample.candidate`;
`rm tmp`;

use strict;
my $seq=shift; my $outdir=shift; my $mark=shift;
open IN,"$seq";
print "$seq\n";
my $line=0;
my %single; my %hash;
while(<IN>){
	chomp;
	for(my $k=1;$k<=37;$k++){
		$seq=substr($_,$k-1,4);
		my $key=$seq."_".$k;
		$single{$key}++;
	}
	for(my $i=1;$i<=33;$i++){
		for(my $j=$i+4;$j<=37;$j++){
			my $seq1=substr($_,$i-1,4);
			my $seq2=substr($_,$j-1,4);
			my $key=$seq1."_".$seq2."_".$i."_".$j;
			$hash{$key}++;
		}
	}
	$line++;
}
close IN;

open OUT,">$outdir/step1.$mark.pair.out";
foreach my $key (keys %hash)
{
		print OUT "$key\t$hash{$key}\n";
}
close OUT;

open OUT,">$outdir/step1.$mark.single.out";
foreach my $key (keys %single)
{
	print OUT "$key\t$single{$key}\n";
}
close OUT;

use strict;
my $batch_file=shift;
open IN,"$batch_file";
open OUT,">step3.sh";
print OUT "rm 6mer.xls\n" if(-e "6mer.xls");
print OUT "rm 8mer.xls\n" if(-e "8mer.xls");
while(<IN>){
	chomp;
	my @t=split;
	next unless($t[0]=~/_/);
	print OUT "perl step3.merge.pl $t[0] $t[2] 5 2 6mer >> 6mer.xls\n";
	print OUT "perl step3.merge.pl $t[0] $t[2] 5 2 8mer >> 8mer.xls\n";
}
close IN;
close OUT;

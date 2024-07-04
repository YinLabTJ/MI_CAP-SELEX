use strict;
my $batch_file=shift; my $seq_file_dir=shift;
open IN,"8mer.filter.xls";
my(%reason,%mark,%m61,%m62,%m81,%m82);
while(<IN>){
	chomp;
	my @t=split;
	$m81{$t[0]}=$t[2];
	$m82{$t[0]}=$t[3];
	if($t[4]){
		$reason{$t[1]}=$t[4];
	}
}
close IN;
open IN,"6mer.filter.xls";
while(<IN>){
	chomp;
	my @t=split;
	$m61{$t[0]}=$t[2];
	$m62{$t[0]}=$t[3];
	if($t[4]){
		$reason{$t[1]}.="," if($reason{$t[1]});
		$reason{$t[1]}.=$t[4];
	}
}
close IN;

open IN,"Curated_Prey_Final.txt";
<IN>;
while(<IN>){
	chomp;
	my @t=split;
	next if(length($t[0])<1);
	my @t2=split /_/,$t[0];
	$mark{$t2[0]}=$t[1]."_".$t[2]."_".$t[3];
	if(@t2>1){
		$mark{$t2[1]}=$t[4]."_".$t[5]."_".$t[6];
	}
}
close IN;

open IN,"$batch_file";
open OUT,">filter.8mer.xls";
<IN>;
my $fail=0; my $pass=0;
while(<IN>){
	chomp;
	my @t=split;
	next if(@t<2);
	my $pair=$t[0]; my $barcode=$t[2];
	my $wc=`wc -l $seq_file_dir/$t[2]$t[3]3u_sig.seq`;
	my @r=split /\s/,$wc;
	if($r[0]<30000){
		$reason{$t[2]}.="," if($reason{$t[2]});
		$reason{$t[2]}.="not_enough_reads";
	}
	print OUT "$pair\t$barcode";
	defined($m81{$pair}) ? print OUT "\t$m81{$pair}" : print OUT "\t/";
	defined($m82{$pair}) ? print OUT "\t$m82{$pair}" : print OUT "\t/";
	defined($m61{$pair}) ? print OUT "\t$m61{$pair}" : print OUT "\t/";
	defined($m62{$pair}) ? print OUT "\t$m62{$pair}" : print OUT "\t/";
	my @p=split /_/,$pair;
	print OUT "\t$t[2]\_$t[3],$mark{$p[0]},$mark{$p[1]}";
	if($reason{$barcode}){
		$fail++;
		print OUT "\t$reason{$barcode}";
	}else{
		$pass++;
	}	
	print OUT "\n";
}
close IN; close OUT;
print "Pass:$pass\n";
print "Failed:$fail\n";

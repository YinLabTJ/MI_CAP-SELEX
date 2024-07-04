use strict;
open IN,"8mer.xls";
open OUT,">8mer.filter.xls";
my($motif1,$motif2,$tf1,$tf2,$pair,$barcode,$pair);

while(<IN>){
	chomp;
	my @t=split;
	if(/^===/){
		$motif1="None" if($motif1 eq "");
		$motif2="None" if($motif2 eq "");
		print OUT "$pair\t$barcode\t$motif1\t$motif2";
		if($tf1==0 && $tf2==0){
			print OUT "\tType3";
		}elsif($tf1==0){
			print OUT "\tType1";
		}elsif($tf2==0){
			print OUT "\tType2";
		}
		print OUT "\n";
	}elsif($t[0]=~/_/){
		$pair=$t[0]; $tf1=0; $tf2=0; $motif1=""; $motif2=""; $barcode=$t[4];
	}else{
		$t[3]=~s/\(local_max\)//g;
		if($t[1] eq "/"){
			$tf2++ if($t[3]>=1.5);
			$motif2.="," if(length($motif2)>2);
			$motif2.=$t[0];
		}elsif($t[2] eq "/"){
			$tf1++ if($t[3]>=1.5);
			$motif1.="," if(length($motif1)>2);
			$motif1.=$t[0];
		}else{
			print "Error: $_\n";
		}
	}
}
close IN; close OUT;

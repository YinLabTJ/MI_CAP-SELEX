use strict;
open IN,"6mer.xls";
open OUT,">6mer.filter.xls";
my($motif1,$motif2,$motif3,$seq,@motif1,@motif2,$barcode,$M1,$M2,$count1,$count2,$match,$pair);
while(<IN>){
	chomp;
	my @t=split;
	if(/^===/){
		$match=0;
		foreach $motif1(@motif1){
			foreach $motif2(@motif2){
				$count1=0; $count2=0;
				my @t1=split //,$motif1;
				my @t2=split //,$motif2;
				$seq=$motif2;
				$seq=~tr/ATCG/TAGC/;
				$motif3=reverse($seq);
				my @t3=split //,$motif3;
				for(my $i=0;$i<@t1;$i++){
					$count1++ if($t1[$i] ne $t2[$i]);
					$count2++ if($t1[$i] ne $t3[$i]);
				}
				if($count1<=1 || $count2<=1){
					$match=1;
				}
			}
		}
		print OUT "$pair\t$barcode\t$M1\t$M2";
		if($match==1){
			if(@motif1==1 && @motif2==1){
				print OUT "\tSame";
			}else{
				print OUT "\tSimilar";
			}
		}
		print OUT "\n";
	}elsif($t[0]=~/_/){
		$pair=$t[0]; $barcode=$t[4]; $M1=""; $M2=""; @motif1=(); @motif2=();
	}else{
		if($t[1] eq "/"){
			push @motif2,$t[0];
			$M2.="," if(length($M2)>2);
			$M2.=$t[0];
		}elsif($t[2] eq "/"){
			push @motif1,$t[0];
			$M1.="," if(length($M1)>2);
			$M1.=$t[0];
		}else{
			print "Error: $_\n";
		}
	}
}
close IN; close OUT;

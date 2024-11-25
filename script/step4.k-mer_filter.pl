use strict;
use File::Spec;

die "Usage: perl step4.k-mer_filter.pl batch_file seq_file_dir\n" unless(@ARGV==2);
my $batch_file=shift; my $seq_file_dir=shift;

my $cwd=File::Spec->rel2abs(__FILE__);
my ($vol,$dir,$file)=File::Spec->splitpath($cwd);


open IN,"spacek40_out/8mer/top_fc.list";
my(%filter_reason,%mark,%m6_1,%m6_2,%m8_1,%m8_2);
my($motif1,$motif2,$tf1,$tf2,$barcode,$pair);

#filter 8-mers which are not enrich enough in cycle r via cycle 0
while(<IN>){
	chomp;
	my @t=split;
	if(/^===/){
		$motif1="None" if($motif1 eq "");
		$motif2="None" if($motif2 eq "");
		$m8_1{$pair}=$motif1;
		$m8_2{$pair}=$motif2;
		if($tf1==0 && $tf2==0){
			$filter_reason{$barcode}="Type3"; 
		}elsif($tf1==0){
			$filter_reason{$barcode}="Type1";
		}elsif($tf2==0){
			$filter_reason{$barcode}="Type2";
		}
	}elsif($t[0]=~/_/){
		#initialize the parameters
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
			print "Format error: $_\n";
		}
	}
}
close IN;


#Filter same or similar (hamming distance < 2) 6-mers in both of the individual TF
open IN,"spacek40_out/6mer/top_fc.list";
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
		$m6_1{$pair}=$M1;
		$m6_2{$pair}=$M2;
		if($match==1){
			$filter_reason{$pair}.="," if($filter_reason{$pair});
			if(@motif1==1 && @motif2==1){
				$filter_reason{$barcode}.="Same";
			}else{
				$filter_reason{$barcode}.="Similar";
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
			print "Format error: $_\n";
		}
	}
}
close IN;


open IN,"$dir/../data/Curated_Prey_Final.txt";
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
`mkdir -p output`;
open OUT,">output/filter_list";
my $fail=0; my $pass=0;
while(<IN>){
	chomp;
	my @t=split;
	next unless($t[0]=~/_/);
	next if(@t<2);
	my $pair=$t[0]; my $barcode=$t[2];
	my $wc=`wc -l $seq_file_dir/$t[2]$t[3]3u_sig.seq`;
	my @r=split /\s/,$wc;
	if($r[0]<30000){
		$filter_reason{$t[2]}.="," if($filter_reason{$t[2]});
		$filter_reason{$t[2]}.="Not_Enough_Reads";
	}
	print OUT "$pair\t$barcode";
	defined($m8_1{$pair}) ? print OUT "\t$m8_1{$pair}" : print OUT "\t/";
	defined($m8_2{$pair}) ? print OUT "\t$m8_2{$pair}" : print OUT "\t/";
	defined($m6_1{$pair}) ? print OUT "\t$m6_1{$pair}" : print OUT "\t/";
	defined($m6_2{$pair}) ? print OUT "\t$m6_2{$pair}" : print OUT "\t/";
	my @p=split /_/,$pair;
	print OUT "\t$t[2]\_$t[3],$mark{$p[0]},$mark{$p[1]}";
	if($filter_reason{$barcode}){
		print OUT "\t$filter_reason{$barcode}";
	}else{
	}	
	print OUT "\n";
}
close IN; close OUT;

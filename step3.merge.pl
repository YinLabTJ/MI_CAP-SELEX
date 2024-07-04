my $pair=shift; my $barcode=shift; my $top_num=shift; my $fc=shift; my $kmer=shift;
my @s=split /_/,$pair;
my @sample;
$sample[0]=$s[0];
$sample[1]=$s[1];
$sample[2]="$pair.$barcode";
foreach $sample(@sample){
	open IN,"spacek40_out/$kmer/$sample.out";
	while(<IN>){
		chomp;
		my @t=split;
		my $seq=$t[5];
		${$sample}{$seq}=$t[11]; 
		if($_=~/local/){
			${$sample}{$seq}.="(local_max)";
		}
	}
	close IN;
}
	
print "$pair\t$s[0]\t$s[1]\t$pair\t$barcode\n";
open IN,"pair_tmp_$kmer/$pair/$s[0].candidate";
my $n=0; my $max=0; my $max2=0; my $line; my $line2;
while(<IN>){
	chomp;
	my @t=split;
	if(${$s[0]}{$t[0]}<3){
		if($max<${$s[0]}{$t[0]}){
			$max=${$s[0]}{$t[0]};
			$line="$t[0]\t${$s[0]}{$t[0]}\t\/\t${$sample[2]}{$t[0]}\n";
		}elsif($max2<${$s[0]}{$t[0]}){
			$max2=${$s[0]}{$t[0]};
			$line2="$t[0]\t${$s[0]}{$t[0]}\t\/\t${$sample[2]}{$t[0]}\n";
		}
		next;
	}
	$n++;
	last if($n>$top_num);
	print "$t[0]\t${$s[0]}{$t[0]}\t\/\t${$sample[2]}{$t[0]}\n";
}
close IN;
if($n==0 && $max>=$fc){
	print "$line";
}
if($n==0 && $max2>=$fc){
        print "$line2";
}

open IN,"pair_tmp_$kmer/$pair/$s[1].candidate";
$n=0; $max=0; $max2=0;
while(<IN>){
        chomp;
        my @t=split;
	if(${$s[1]}{$t[0]}<3){
		if($max<${$s[1]}{$t[0]}){
			$max=${$s[1]}{$t[0]};
			$line="$t[0]\t\/\t${$s[1]}{$t[0]}\t${$sample[2]}{$t[0]}\n";
		}elsif($max2<${$s[1]}{$t[0]}){
                        $max2=${$s[1]}{$t[0]};
                        $line2="$t[0]\t\/\t${$s[1]}{$t[0]}\t${$sample[2]}{$t[0]}\n";
                }
		next;
	}
        $n++;
        last if($n>$top_num);
        print "$t[0]\t\/\t${$s[1]}{$t[0]}\t${$sample[2]}{$t[0]}\n";
}
close IN;
if($n==0 && $max>=$fc){
        print "$line";
}
if($n==0 && $max2>=$fc){
        print "$line2";
}

print "===\n";

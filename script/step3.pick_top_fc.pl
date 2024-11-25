#!/usr/bin/perl
die "Usage: perl step3.pick_top_fc.pl batch_file\n" unless(@ARGV==1);

my $batch_file=shift; 
my $top_num=5;
my $fc=2;
my @kmer=qw/6mer 8mer/;
foreach my $kmer(@kmer){
	open OUT,">spacek40_out/$kmer/top_fc.list";
	open IN,"$batch_file";
	while(<IN>){
		chomp;
		my @b=split;
		next unless($b[0]=~/_/);
		my @sample;
		@tf=split /_/,$b[0];
		$sample[0]=$tf[0]; $sample[1]=$tf[1]; $sample[2]="$b[0].$b[2]";
		foreach my $sample(@sample){
			open SPACEK,"spacek40_out/$kmer/$sample.out";	
			while(<SPACEK>){
				chomp;
				my @t=split;
				my $seq=$t[5];
				${$sample}{$seq}=$t[11];
				if($_=~/local_max/){
					${$sample}{$seq}.="(local_max)";
				}
			}
			close SPACEK;
		}
		print OUT "$b[0]\t$tf[0]\t$tf[1]\t$b[0]\t$b[2]\n";
		open CAN,"spacek40_out/$kmer/$sample[0].candidate";
		my $n=0; my $max=0; my $max2=0; my $line; my $line2;
		while(<CAN>){
			chomp;
			my @t=split;
			if(${$sample[0]}{$t[0]}<3){
				if($max<${$sample[0]}{$t[0]}){
					$max=${$sample[0]}{$t[0]};
					$line="$t[0]\t${$s[0]}{$t[0]}\t\/\t${$sample[2]}{$t[0]}\n";
				}elsif($max2<${$sample[0]}{$t[0]}){
					$max2=${$sample[0]}{$t[0]};
					$line2="$t[0]\t${$s[0]}{$t[0]}\t\/\t${$sample[2]}{$t[0]}\n";
				}
				next;
			}
			$n++;
			last if($n>$top_num);
			print OUT "$t[0]\t${$sample[0]}{$t[0]}\t\/\t${$sample[2]}{$t[0]}\n";
		}
		close CAN;

		#if highedt fold changes of k-mers are lower than 3 but higher than 2, only pick the top 2 k-mers
		if($n==0 && $max>=$fc){
			print OUT "$line";
		}
		if($n==0 && $max2>=$fc){
			print OUT "$line2";
		}
		open CAN,"spacek40_out/$kmer/$sample[1].candidate";
		$n=0; $max=0; $max2=0;
		while(<CAN>){
			chomp;
			my @t=split;
			if(${$sample[1]}{$t[0]}<3){
				if($max<${$sample[1]}{$t[0]}){
					$max=${$sample[1]}{$t[0]};
					$line="$t[0]\t\/\t${$sample[1]}{$t[0]}\t${$sample[2]}{$t[0]}\n";
				}elsif($max2<${$sample[1]}{$t[0]}){
					$max2=${$sample[1]}{$t[0]};
					$line2="$t[0]\t\/\t${$sample[1]}{$t[0]}\t${$sample[2]}{$t[0]}\n";
				}
				next;
			}
			$n++;
			last if($n>$top_num);
			print OUT "$t[0]\t\/\t${$sample[1]}{$t[0]}\t${$sample[2]}{$t[0]}\n";
		}
		close CAN;
		if($n==0 && $max>=$fc){
			print OUT "$line";
		}
		if($n==0 && $max2>=$fc){
			print OUT "$line2";
		}
		print OUT "===\n";
	}
	close IN; close OUT;
}

use strict;
use Cwd;
use File::Spec;

die "Usage: perl step5.4-mer_frequency.pl sequence_file_dir\n" unless(@ARGV==1);

my $dir=cwd;
my $cwd=File::Spec->rel2abs(__FILE__);
my ($vol,$shdir,$file)=File::Spec->splitpath($cwd);

my $seq_file_dir=shift;

my $datestring = localtime();
print "4-mer frequncy counting start at $datestring\n";


open IN,"output/filter_list";
`mkdir -p output`;
open OUT,">output/step6.sh";
while(<IN>){
	chomp;
	my @t=split;
	if(@t<8){
		my @t1=split /_/,$t[0];
		my @t2=split /,/,$t[6];
		$t2[0]=~s/_//g; $t2[1]=~s/_//g; $t2[2]=~s/_//g;
		my $seqfile="$seq_file_dir/$t2[0]3u_sig.seq";
		my $tf1="$seq_file_dir/$t2[1]\_sig.seq";
		my $tf2="$seq_file_dir/$t2[2]\_sig.seq";
		`mkdir -p $dir/output/$t[0]\_$t2[0]`;
		`mkdir -p $dir/output/MI_figures/$t[0]\_$t2[0]`;

		my @seqfile_list=($seqfile,$tf1,$tf2); my @tf_mark=qw/tf_pair tf1 tf2/;
		my $seq;
		for(my $tf_n=0;$tf_n<=2;$tf_n++){
			open SEQ,"$seqfile_list[$tf_n]";
			my $line=0;
			my %single; my %hash;
			while(<SEQ>){
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
			close SEQ;
			open OUT1,">$dir/output/$t[0]\_$t2[0]/$tf_mark[$tf_n].4-mer_pair.out";
			foreach my $key (keys %hash)
			{
				print OUT1 "$key\t$hash{$key}\n";
			}
			close OUT1;
			open OUT1,">$dir/output/$t[0]\_$t2[0]/$tf_mark[$tf_n].4-mer.out";
			foreach my $key (keys %single)
			{
				print OUT1 "$key\t$single{$key}\n";
			}
			close OUT1;
		}

		
		my @t81=split /,/,$t[2];
		my @t82=split /,/,$t[3];
		print "$t[0] : counting 4-mer pairs frequency...\n";
		foreach my $t81(@t81){
			foreach my $t82(@t82){
				print OUT "perl $dir/script/step6_MI_heatmap_drawing.pl $seqfile $t81\_$t82 $t[0] $t[2]\_$t[3] 8 4 $dir/output/$t[0]\_$t2[0] tf_pair 1 > $dir/output/MI_figures/$t[0]\_$t2[0]/$t81\_$t82.svg\n";
				print OUT "perl $dir/script/step6_MI_heatmap_drawing.pl $tf1 $t81\_$t82 $t[0] $t[2]\_$t[3] 8 4 $dir/output/$t[0]\_$t2[0] tf1 1 > $dir/output/MI_figures/$t[0]\_$t2[0]/$t81\_$t82.tf1.svg\n";
				print OUT "perl $dir/script/step6_MI_heatmap_drawing.pl $tf2 $t81\_$t82 $t[0] $t[2]\_$t[3] 8 4 $dir/output/$t[0]\_$t2[0] tf2 1 > $dir/output/MI_figures/$t[0]\_$t2[0]/$t81\_$t82.tf2.svg\n";

				
				print OUT "perl $dir/script/step6_MI_heatmap_drawing_shift.pl $seqfile $t81\_$t82 $t[0] $t[2]\_$t[3] 7 4 $dir/output/$t[0]\_$t2[0] tf_pair 1 > $dir/output/MI_figures/$t[0]\_$t2[0]/$t81\_$t82.shift.svg\n";
				print OUT "perl $dir/script/step6_MI_heatmap_drawing_shift.pl $tf1 $t81\_$t82 $t[0] $t[2]\_$t[3] 7 4 $dir/output/$t[0]\_$t2[0] tf1 1 >  $dir/output/MI_figures/$t[0]\_$t2[0]/$t81\_$t82.shift.tf1.svg\n";
				print OUT "perl $dir/script/step6_MI_heatmap_drawing_shift.pl $tf2 $t81\_$t82 $t[0] $t[2]\_$t[3] 7 4 $dir/output/$t[0]\_$t2[0] tf2 1 >  $dir/output/MI_figures/$t[0]\_$t2[0]/$t81\_$t82.shift.tf2.svg\n";
				print OUT "perl $dir/script/step6_remove_enriched-4mer-pairs_in_individual_TF.pl $dir/output/$t[0]\_$t2[0]/MI.$t[0].$t81\_$t82.tf_pair.shift.xls $dir/output/$t[0]\_$t2[0]/MI.$t[0].$t81\_$t82.tf1.shift.xls $dir/output/$t[0]\_$t2[0]/MI.$t[0].$t81\_$t82.tf2.shift.xls $t81\_$t82 $t[0] $t[2]\_$t[3] 7 4 $dir/output/$t[0]\_$t2[0] $dir/output/$t[0]\_$t2[0]/MI.$t[0].$t81\_$t82.tf_pair-tf1-tf2.shift.xls > $dir/output/MI_figures/$t[0]\_$t2[0]/$t81\_$t82.tf_pair-tf1-tf2.shift.svg\n";
			}
		}
		print "$t[0] : 4-mer pairs frequency counted.\n";
	}
}
close IN;
close OUT;
$datestring = localtime();
print "4-mer frequncy counting finish at $datestring\n";

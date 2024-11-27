use MI; # /etc/perl/MI.pm
use File::Spec;
my $cwd=File::Spec->rel2abs(__FILE__);
my ($vol,$shdir,$file)=File::Spec->splitpath($cwd);

$seq=shift; $pair_8=shift; $tf_pair=shift; $pair_8s=shift; $lkmer=shift; $skmer=shift; $s1dir=shift; $tf=shift; $dis_file=shift;
$wc=`wc -l $seq`;
@t=split /\s/,$wc;
$total=$t[0];
@t=split /_/,$pair_8;
open HEAT,">$s1dir/heatmap.xls";
$palindrome=0;
@s=split /_/,$pair_8s;
@s1=split /,/,$s[0];
@s2=split /,/,$s[1];

@tf=split /_/,$tf_pair;
open(IN, "$shdir/../data/$skmer-mer.xls") or die "k-mer.xls ......, $!";
while(<IN>){
        chomp;
        @mer_t=split;
        if($mer_t[0] eq $tf[0]){
                @mer=split /,/,$mer_t[1];
                foreach $mer(@mer){
                        $degenerate1{$mer}=1;
                }
        }elsif($mer_t[0] eq $tf[1]){
                @mer=split /,/,$mer_t[1];
                foreach $mer(@mer){
                        $degenerate2{$mer}=1;
                }
        }
}
close IN;


for($j=0;$j<@s1;$j++){
	for($k=0;$k<@s2;$k++){

		for($i=1;$i<=$lkmer-$skmer+1;$i++){
			$seq1=substr($s1[$j],$i-1,$skmer);
			$seq2=substr($s2[$k],$i-1,$skmer);
			$seq1r=reverse($seq1);
			$seq2r=reverse($seq2);
			$seq1r=~tr/ATCG/TAGC/;
			$seq2r=~tr/ATCG/TAGC/;
			$tf1{$seq1}=1; $tf1{$seq1r}=1;
			$tf2{$seq2}=1; $tf2{$seq2r}=1;
		}
	}
}

$rev1=reverse($t[0]); $rev1=~tr/ATCG/TAGC/;
$revs=reverse($t[1]); $revs=~tr/ATCG/TAGC/;


for($i=1;$i<=$lkmer-$skmer+1;$i++){
	$seq1=substr($t[0],$i-1,$skmer);
	$seq2=substr($t[1],$i-1,$skmer);
	$seq1r=reverse($seq1);
	$seq1r=~tr/ATCG/TAGC/;
	$seq2r=reverse($seq2);
	$seq2r=~tr/ATCG/TAGC/;
	unless(($tf1{$seq1}==1 && $tf2{$seq1}==1) || ($tf1{$seq2}==1 && $tf2{$seq2}==1) || $degenerate2{$seq1}==1 || $degenerate1{$seq2}==1){
		$comb1=$seq1."_".$seq2; 
		$comb2=$seq2."_".$seq1;
		$comb3=$seq1r."_".$seq2r;
		$comb4=$seq2r."_".$seq1r;
		$input[0]=$t[0]; $input[1]=$comb1; $huddinge1=Huddinge(@input);
		$input[0]=$t[1]; $input[1]=$comb1; $huddinge2=Huddinge(@input);
		if($huddinge1>1 && $huddinge2>1){ $hash{$comb1}=1; $hash1{$comb1}=1; }
		$input[0]=$t[0]; $input[1]=$comb2; $huddinge1=Huddinge(@input);
		$input[0]=$t[1]; $input[1]=$comb2; $huddinge2=Huddinge(@input);
		if($huddinge1>1 && $huddinge2>1){ $hash{$comb2}=1; $hash2{$comb2}=1; }
		$input[0]=$rev1; $input[1]=$comb3; $huddinge1=Huddinge(@input);
		$input[0]=$revs; $input[1]=$comb3; $huddinge2=Huddinge(@input);
		if($huddinge1>1 && $huddinge2>1){ $hash{$comb3}=1; $hash2{$comb3}=1; }
		$input[0]=$rev1; $input[1]=$comb4; $huddinge1=Huddinge(@input);
		$input[0]=$revs; $input[1]=$comb4; $huddinge2=Huddinge(@input);
		if($huddinge1>1 && $huddinge2>1){ $hash{$comb4}=1; $hash1{$comb4}=1; }
	}
	$seq3=substr($revs,$i-1,$skmer);
	$seq3r=reverse($seq3);
	$seq3r=~tr/ATCG/TAGC/;
	unless(($tf1{$seq1}==1 && $tf2{$seq1}==1) || ($tf1{$seq3}==1 && $tf2{$seq3}==1) || $degenerate2{$seq1}==1 || $degenerate1{$seq3}==1){
		$comb5=$seq1."_".$seq3;
		$comb6=$seq3."_".$seq1;
		$comb7=$seq1r."_".$seq3r;
		$comb8=$seq3r."_".$seq1r;
		$input[0]=$t[0]; $input[1]=$comb5; $huddinge1=Huddinge(@input);
		$input[0]=$revs; $input[1]=$comb5; $huddinge2=Huddinge(@input);
		if($huddinge1>1 && $huddinge2>1){ $hash{$comb5}=1; $hash3{$comb5}=1; }
		$input[0]=$t[0]; $input[1]=$comb6; $huddinge1=Huddinge(@input);
		$input[0]=$revs; $input[1]=$comb6; $huddinge2=Huddinge(@input);
		if($huddinge1>1 && $huddinge2>1){ $hash{$comb6}=1; $hash4{$comb6}=1; }
		$input[0]=$rev1; $input[1]=$comb7; $huddinge1=Huddinge(@input);
		$input[0]=$t[1]; $input[1]=$comb7; $huddinge2=Huddinge(@input);
		if($huddinge1>1 && $huddinge2>1){ $hash{$comb7}=1; $hash4{$comb7}=1; }
		$input[0]=$rev1; $input[1]=$comb8; $huddinge1=Huddinge(@input);
		$input[0]=$t[1]; $input[1]=$comb8; $huddinge2=Huddinge(@input);
		if($huddinge1>1 && $huddinge2>1){ $hash{$comb8}=1; $hash3{$comb8}=1; }
	}
}
if($t[0] eq $rev1 && $t[1] eq $revs){
	$palindrome=3;
}elsif($t[0] eq $rev1){
	$palindrome=1;
}elsif($t[1] eq $revs){
	$palindrome=2;
}

print HEAT "palindrome=$palindrome\n";
open IN,"$s1dir/$tf.4-mer.out";
while(<IN>){
	chomp;
	@t=split;
	$single{$t[0]}=$t[1];
}
close IN;
$max=0;
open IN,"$dis_file";
$dis_check=<IN>;
chomp($dis_check);
@dis=split /,/,$dis_check;
foreach $dis(@dis){
	$dis_c{$dis}=1;
}
close IN;
open IN,"$s1dir/$tf.4-mer_pair.out";
open TMP,">$s1dir/tmp";
while(<IN>){
	chomp;
	@s=split;
	@t=split /_/,$s[0];
	$pair=$t[0]."_".$t[1];
	$key1=$t[0]."_".$t[2];
	$key2=$t[1]."_".$t[3];
	if($hash{$pair}==1){
		$fenshu=$s[1]*$total/($single{$key1}*$single{$key2}); 
		$mi{$t[2]}{$t[3]}+=$s[1]/$total*log($fenshu)/log(2);
		$max=$mi{$t[2]}{$t[3]} if($max<$mi{$t[2]}{$t[3]});
		$tmp=$s[1]/$total*log($fenshu)/log(2);
		$dis=$t[3]-$t[2];
		print TMP "$key1\_$key2\t$pair\t$tmp\n" if($dis_c{$dis}==1);
	}
}
close IN; close TMP;

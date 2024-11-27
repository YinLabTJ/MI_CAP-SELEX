use SVG;
use MI; # /etc/perl/MI.pm
use File::Spec;
my $cwd=File::Spec->rel2abs(__FILE__);
my ($vol,$shdir,$file)=File::Spec->splitpath($cwd);

my $svg=SVG->new('width',1000,'height',1000);
$seq=shift; $pair_8=shift; $tf_pair=shift; $pair_8s=shift; $lkmer=shift; $skmer=shift; $s1dir=shift; $tf=shift; $file_mark=shift; $filter_file=shift;
$wc=`wc -l $seq`;
@t=split /\s/,$wc;
$total=$t[0];
@t=split /_/,$pair_8;
open HEAT,">$s1dir/heatmap.xls";
$palindrome=0;

open IN,"$filter_file";
$i=0;
while(<IN>){
	chomp;
	@r=split;
	$key=$r[0]."_".$r[1];
	$filter{$key}=1;
	$filter[$i]=$key;
	$i++;
}
close IN;

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


@s=split /_/,$pair_8s;
@s1=split /,/,$s[0];
@s2=split /,/,$s[1];
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
		$input[0]=$t[0]; $input[1]=$comb1; $huddinge1=Huddinge(@input); #Hudding distance
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
open IN,"$s1dir/$tf.4-mer_pair.out";
$max=0;
while(<IN>){
	chomp;
	@s=split;
	@t=split /_/,$s[0];
	$pair=$t[0]."_".$t[1];
	$key1=$t[0]."_".$t[2];
	$key2=$t[1]."_".$t[3];
	$distance=$t[3]-$t[2];
	$key=$distance."_".$pair;
	next if($filter{$key}==1); #need to be filtered
	if($hash{$pair}==1){
		$fraction=$s[1]*$total/($single{$key1}*$single{$key2}); 
		$mi{$t[2]}{$t[3]}+=$s[1]/$total*log($fraction)/log(2);
		$max=$mi{$t[2]}{$t[3]} if($max<$mi{$t[2]}{$t[3]});
		$tmp=$s[1]/$total*log($fraction)/log(2);
	}
	if($hash1{$pair}==1){$fraction=$s[1]*$total/($single{$key1}*$single{$key2}); $mi1{$t[2]}{$t[3]}+=$s[1]/$total*log($fraction)/log(2); }
	if($hash2{$pair}==1){$fraction=$s[1]*$total/($single{$key1}*$single{$key2}); $mi2{$t[2]}{$t[3]}+=$s[1]/$total*log($fraction)/log(2); }
	if($hash3{$pair}==1){$fraction=$s[1]*$total/($single{$key1}*$single{$key2}); $mi3{$t[2]}{$t[3]}+=$s[1]/$total*log($fraction)/log(2); }
	if($hash4{$pair}==1){$fraction=$s[1]*$total/($single{$key1}*$single{$key2}); $mi4{$t[2]}{$t[3]}+=$s[1]/$total*log($fraction)/log(2); }
}
close IN;
open OUT,">$s1dir/MI.tmp.xls";
$total_num_of_matrix=0;
for($j=40-$skmer+1;$j>=$skmer+1;$j--){
	for($i=1;$i<=$j-$skmer;$i++){
		$distance=$j-$i;
		if(defined($mi{$i}{$j})){
			print OUT "$distance\t$mi{$i}{$j}";
		}else{
			print OUT "$distance\t-100";
		}
		$total_num_of_matrix++;
		print OUT "\n" unless($j==$skmer+1 && $i==1);
		if($i>=10-$skmer+1 && $j<=31){ #assume length of binding site is 10-bp
			$dis=$j-$i;
			$xforr{$dis}.="," if(defined($xforr{$dis}));
			$xforr{$dis}.=$mi{$i}{$j};
			$xforr1{$dis}.="," if(defined($xforr1{$dis})); $xforr1{$dis}.=$mi1{$i}{$j};
			$xforr2{$dis}.="," if(defined($xforr2{$dis})); $xforr2{$dis}.=$mi2{$i}{$j};
			$xforr3{$dis}.="," if(defined($xforr3{$dis})); $xforr3{$dis}.=$mi3{$i}{$j};
			$xforr4{$dis}.="," if(defined($xforr4{$dis})); $xforr4{$dis}.=$mi4{$i}{$j};
		}
	}
}
close OUT;
open XFORR,">$s1dir/x.forR.xls";
foreach $key(sort {$a<=>$b} keys %xforr){
	@t=split /,/,$xforr{$key};
	if(@t>=7){
		print XFORR "$key";
		$sum=0;
		for($i=0;$i<@t;$i++){
			print XFORR "\t$t[$i]";
			$sum+=$t[$i];
		}
		print XFORR "\n";
		$avr{$key}=$sum/@t;
	}
}

close XFORR;

$maxheat=0;
foreach $key(sort {$a<=>$b} keys %xforr1){
	@t=split /,/,$xforr1{$key};
	if(@t>0){
		$sum=0;
		for($i=0;$i<@t;$i++){
			$sum+=$t[$i];
		}
		$avr1{$key}=$sum/@t;
		$maxheat=$avr1{$key} if($maxheat<$avr1{$key});
		$minheat=$avr1{$key} if($minheat>$avr1{$key});
	}
}
foreach $key(sort {$a<=>$b} keys %xforr2){
	@t=split /,/,$xforr2{$key};
	if(@t>0){
		$sum=0;
		for($i=0;$i<@t;$i++){
			$sum+=$t[$i];
		}
		$avr2{$key}=$sum/@t;
		$maxheat=$avr2{$key} if($maxheat<$avr2{$key});
		$minheat=$avr2{$key} if($minheat>$avr2{$key});
	}
}
foreach $key(sort {$a<=>$b} keys %xforr3){
	@t=split /,/,$xforr3{$key};
	if(@t>0){
		$sum=0;
		for($i=0;$i<@t;$i++){
			$sum+=$t[$i];
		}
		$avr3{$key}=$sum/@t;
		$maxheat=$avr3{$key} if($maxheat<$avr3{$key});
		$minheat=$avr3{$key} if($minheat>$avr3{$key});
	}
}
foreach $key(sort {$a<=>$b} keys %xforr4){
	@t=split /,/,$xforr4{$key};
	if(@t>0){
		$sum=0;
		for($i=0;$i<@t;$i++){
			$sum+=$t[$i];
		}
		$avr4{$key}=$sum/@t;
		$maxheat=$avr4{$key} if($maxheat<$avr4{$key});
		$minheat=$avr4{$key} if($minheat>$avr4{$key});
		print HEAT "1\t$key\t$avr1{$key}\n";
		print HEAT "2\t$key\t$avr2{$key}\n"; 
		print HEAT "3\t$key\t$avr3{$key}\n"; 
		print HEAT "4\t$key\t$avr4{$key}\n"; 
	}
}
close HEAT;

if($palindrome==0){
	$svg->polygon('points','360,602 360,618 380,610','style',"fill:black;stroke:black;stroke-width:1");
	$svg->polygon('points','390,602 390,618 410,610','style',"fill:white;stroke:black;stroke-width:1");
	$svg->polygon('points','360,622 360,638 380,630','style',"fill:white;stroke:black;stroke-width:1");
	$svg->polygon('points','390,622 390,638 410,630','style',"fill:black;stroke:black;stroke-width:1");
	$svg->polygon('points','360,642 360,658 380,650','style',"fill:black;stroke:black;stroke-width:1");
	$svg->polygon('points','410,642 410,658 390,650','style',"fill:white;stroke:black;stroke-width:1");
	$svg->polygon('points','380,662 380,678 360,670','style',"fill:white;stroke:black;stroke-width:1");
	$svg->polygon('points','390,662 390,678 410,670','style',"fill:black;stroke:black;stroke-width:1");
}
if($palindrome==1){
	$svg->circle('cx',370,'cy',610,'r',8,'style','fill:black');
	$svg->polygon('points','390,602 390,618 410,610','style',"fill:white;stroke:black;stroke-width:1");
	$svg->polygon('points','360,622 360,638 380,630','style',"fill:white;stroke:black;stroke-width:1");
	$svg->circle('cx',400,'cy',630,'r',8,'style','fill:black');
}
if($palindrome==2){
	$svg->polygon('points','360,602 360,618 380,610','style',"fill:black;stroke:black;stroke-width:1");
	$svg->circle('cx',400,'cy',610,'r',8,'style','fill:white;stroke:black');
	$svg->circle('cx',370,'cy',630,'r',8,'style','fill:white;stroke:black');
	$svg->polygon('points','390,622 390,638 410,630','style',"fill:black;stroke:black;stroke-width:1");
}
if($palindrome==3){
	$svg->circle('cx',370,'cy',610,'r',8,'style','fill:black');
	$svg->circle('cx',400,'cy',610,'r',8,'style','fill:white;stroke:black');
}
foreach $key(sort {$a<=>$b} keys %xforr){
	@t=split /,/,$xforr{$key};
	$x=350+20*$key;
	$distance=$key-8;
	$svg->text('x',$x+5,'y',590,'fill','black','stroke','black','-cdata',$distance,'font-size',10,'style','stroke-width:0');
	
	if($maxheat==0){
		$red=211; $green=211; $blue=211;
	}else{
		$red=211-$avr1{$key}/$maxheat*211; $red=211 if($red>211);
		$green=211-$avr1{$key}/$maxheat*(211-191); $green=211 if($green>211);
		$blue=211+$avr1{$key}/$maxheat*(255-211); $blue=211 if($blue<211);
	}
	$color=$color="rgb(".$red.",".$green.",".$blue.")";
	
	$svg->rect('x',$x,'y',600,'width',20,'height',20,'opacity',1,'fill',$color);
	if($palindrome<3){
		
		if($maxheat==0){
			$red=211; $green=211; $blue=211;
		}else{	
			$red=211-$avr2{$key}/$maxheat*211; $red=211 if($red>211);
			$green=211-$avr2{$key}/$maxheat*(211-191); $green=211 if($green>211);
			$blue=211+$avr2{$key}/$maxheat*(255-211); $blue=211 if($blue<211);
		}
		$color=$color="rgb(".$red.",".$green.",".$blue.")";
		
		$svg->rect('x',$x,'y',620,'width',20,'height',20,'opacity',1,'fill',$color);
	}
	if($palindrome==0){
		
		if($maxheat==0){
			$red=211; $green=211; $blue=211;
		}else{
			$red=211-$avr3{$key}/$maxheat*211; $red=211 if($red>211);
			$green=211-$avr3{$key}/$maxheat*(211-191); $green=211 if($green>211);
			$blue=211+$avr3{$key}/$maxheat*(255-211); $blue=211 if($blue<211);
		}
		$color=$color="rgb(".$red.",".$green.",".$blue.")";
		$svg->rect('x',$x,'y',640,'width',20,'height',20,'opacity',1,'fill',$color);
		
		if($maxheat==0){
			$red=211; $green=211; $blue=211;
		}else{
			$red=211-$avr4{$key}/$maxheat*211; $red=211 if($red>211);
			$green=211-$avr4{$key}/$maxheat*(211-191); $green=211 if($green>211);
			$blue=211+$avr4{$key}/$maxheat*(255-211); $blue=211 if($blue<211);
		}
		$color=$color="rgb(".$red.",".$green.",".$blue.")";
		
		$svg->rect('x',$x,'y',660,'width',20,'height',20,'opacity',1,'fill',$color);
	}
}

`cd $s1dir && perl $shdir/create_anova.pl && Rscript $shdir/oneway-anova.R > oneway-anova.out && Rscript $shdir/welchs-anova.R > welchs-anova.out && cd ..`;

open IN,"$s1dir/oneway-anova.out";
while(<IN>){
	chomp;
	@t=split;
	if($t[0] eq "A"){
		$owP="one-way ANOVA: P-value";
		$owP.="=" unless($t[5]=~/</);
		$owP.=$t[5];
	}
}
close IN;
open IN,"$s1dir/welchs-anova.out";
while(<IN>){
	chomp;
	@t=split;
	if($t[0] eq "F"){
		$_=~s/.*p-value//;
		$welchP="Welch's ANOVA: P-value".$_;
	}
}
close IN;

`sort -k2,2rg $s1dir/MI.tmp.xls > $s1dir/MI.tmp2.xls`;
`rm $s1dir/MI.tmp.xls`;
`cd $s1dir && perl $shdir/top_distance.pl > top_distance.xls && cd ..`;
`mv $s1dir/MI.tmp2.xls $s1dir/MI.$tf_pair.$pair_8.$tf.$file_mark.sort.xls`;
open IN,"$s1dir/top_distance.xls";
while(<IN>){
	chomp;
	@t=split;
	if(!defined($dis_start_x)){
		$dis_start_x=500;
		$dis_start_y=550;
	}
	$dis_end_x=490+$t[0]*2;
	$dis_end_y=550-$t[1]*5;
	$svg->line('x1',$dis_start_x,'y1',$dis_start_y,'x2',$dis_end_x,'y2',$dis_end_y,'stroke','black','stroke-width',1);
	$newx=$dis_end_x+10;
	$svg->line('x1',$dis_end_x,'y1',$dis_end_y,'x2',$newx,'y2',$dis_end_y,'stroke','black','stroke-width',1);
	$dis_start_x=$newx; $dis_start_y=$dis_end_y;
}
$svg->line('x1',500,'y1',550,'x2',710,'y2',550,'stroke','black','stroke-width',1);
$svg->line('x1',500,'y1',550,'x2',500,'y2',390,'stroke','black','stroke-width',1);
$svg->text('x',580,'y',565,'fill','black','stroke','black','-cdata','50','font-size',10,'style','stroke-width:0');
$svg->text('x',680,'y',565,'fill','black','stroke','black','-cdata','100','font-size',10,'style','stroke-width:0');
$svg->text('x',480,'y',500,'fill','black','stroke','black','-cdata','10','font-size',10,'style','stroke-width:0');
$svg->text('x',480,'y',450,'fill','black','stroke','black','-cdata','20','font-size',10,'style','stroke-width:0');
$svg->text('x',480,'y',400,'fill','black','stroke','black','-cdata','30','font-size',10,'style','stroke-width:0');

$svg->line('x1',500,'y1',525,'x2',495,'y2',525,'stroke','black','stroke-width',1);
$svg->line('x1',500,'y1',475,'x2',495,'y2',475,'stroke','black','stroke-width',1);
$svg->line('x1',500,'y1',425,'x2',495,'y2',425,'stroke','black','stroke-width',1);
$svg->line('x1',500,'y1',500,'x2',495,'y2',500,'stroke','black','stroke-width',1);
$svg->line('x1',500,'y1',450,'x2',495,'y2',450,'stroke','black','stroke-width',1);
$svg->line('x1',500,'y1',400,'x2',495,'y2',400,'stroke','black','stroke-width',1);

$svg->line('x1',540,'y1',550,'x2',540,'y2',555,'stroke','black','stroke-width',1);
$svg->line('x1',590,'y1',550,'x2',590,'y2',555,'stroke','black','stroke-width',1);
$svg->line('x1',640,'y1',550,'x2',640,'y2',555,'stroke','black','stroke-width',1);
$svg->line('x1',690,'y1',550,'x2',690,'y2',555,'stroke','black','stroke-width',1);

close IN;
open OUT,">$s1dir/MI.$tf_pair.$pair_8.$tf.$file_mark.xls";
for($i=1;$i<=40-$skmer*2+1;$i++){
	print OUT "\t$i";
}
print OUT "\n";
for($j=40-$skmer+1;$j>=$skmer+1;$j--){
	print OUT "$j";
	$y=100+(40-$skmer+1-$j)*20;
	for($i=1;$i<=$j-$skmer;$i++){
		$x=100+($i-1)*20;
		if(defined($mi{$i}{$j})){
			print OUT "\t$mi{$i}{$j}";
			
			$num=$mi{$i}{$j}/$max;
			$num=1 if($num>1); $num=0 if($num<0);
			$blue1=255-int($num/1*255);
			$green1=255-int($num/1*(255-191));
			$color="rgb(".$blue1.",".$green1.",255)";
		}else{
			print OUT "\t-100";
			$color="rgb(255,255,255)";
		}
		$svg->rect('x',$x,'y',$y,'width',20,'height',20,'opacity',1,'fill',$color);
	}
	print OUT "\n";
}
close OUT;
$text=$tf_pair.": ".$pair_8." ".$skmer."-mers in ".$lkmer."-mer";
$max=920-$skmer*40;
$svg->text('x',150,'y',20,'fill','black','stroke','black','-cdata',$text,'font-size',25);
$svg->line('x1',90,'y1',100,'x2',$max,'y2',100,'stroke','black','stroke-width',1);
$svg->line('x1',100,'y1',90,'x2',100,'y2',$max,'stroke','black','stroke-width',1);
$svg->line('x1',90,'y1',$max,'x2',100,'y2',$max,'stroke','black','stroke-width',1);
$svg->line('x1',$max,'y1',90,'x2',$max,'y2',100,'stroke','black','stroke-width',1);
$svg->line('x1',$max,'y1',100,'x2',100,'y2',$max,'stroke','black','stroke-dasharray','2,5','style','fill:none;stroke:black;stroke-width=2px');
$svg->text('x',105,'y',70,'fill','black','stroke','black','-cdata','1','font-size',25);
$xm=$max-15; $txt1=40-$skmer*2+1; $txt2=40-$skmer+1;
$svg->text('x',$xm,'y',70,'fill','black','stroke','black','-cdata',$txt1,'font-size',25);
$svg->text('x',60,'y',110,'fill','black','stroke','black','-cdata',$txt2,'font-size',25);
$ym=$max-10; $txt1=$skmer+1;
$svg->text('x',65,'y',$ym,'fill','black','stroke','black','-cdata',$txt1,'font-size',25);

$svg->text('x',250,'y',730,'fill','black','stroke','black','-cdata',$owP,'font-size',15,'style','stroke-width:0');
$svg->text('x',250,'y',770,'fill','black','stroke','black','-cdata',$welchP,'font-size',15,'style','stroke-width:0');

$svg->text('x',710,'y',200,'fill','black','stroke','black','-cdata','distance','font-size',15,'style','stroke-width:1');
$svg->text('x',830,'y',200,'fill','black','stroke','black','-cdata','MI','font-size',15,'style','stroke-width:1');
$svg->text('x',830,'y',182,'fill','black','stroke','black','-cdata','__','font-size',15,'style','stroke-width:1');
foreach $key(sort {$a<=>$b} keys %avr){
	$y=150+$key*20;
	$svg->text('x',740,'y',$y,'fill','black','stroke','black','-cdata',$key,'font-size',10,'style','stroke-width:0');
	$svg->text('x',790,'y',$y,'fill','black','stroke','black','-cdata',$avr{$key},'font-size',10,'style','stroke-width:0');
}

$dis_order=0;
$svg->text('x',530,'y',780,'fill','black','stroke','black','-cdata','distance','font-size',10,'style','stroke-width:0');
$svg->text('x',580,'y',780,'fill','black','stroke','black','-cdata','4mer-pairs_removed','font-size',10,'style','stroke-width:0');
$x1=550; $y0=800;
foreach $key(@filter){
	@t=split /_/,$key;
	if($y>=880){
		$y0=$y0-100;
		$x1=$x1+150;
	}
	$pair=$t[1]."_".$t[2];
	$y=$y0+$dis_order*20;
	$x2=$x1+50;
	$svg->text('x',$x1,'y',$y,'fill','black','stroke','black','-cdata',$t[0],'font-size',10,'style','stroke-width:0');
	$svg->text('x',$x2,'y',$y,'fill','black','stroke','black','-cdata',$pair,'font-size',10,'style','stroke-width:0');
	$dis_order++;
}

my $out=$svg->xmlify;
print $out;

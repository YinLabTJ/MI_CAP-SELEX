use SVG;
use Cwd;
use File::Spec;
use MI; # /etc/perl/MI.pm
my $svg=SVG->new('width',1000,'height',1000);
$t1t2=shift; $t1=shift; $t2=shift; $pair_8=shift; $te_pair=shift; $pair_8s=shift; $lkmer=shift; $skmer=shift;  $s1dir=shift; $output=shift;

my $dir=cwd;
my $cwd=File::Spec->rel2abs(__FILE__);
my ($vol,$shdir,$file)=File::Spec->splitpath($cwd);
open IN,"$t1t2";
$tytle=<IN>;
chomp($tytle);
@t=split /\t/,$tytle;
for($i=1;$i<@t;$i++){
	$first{$i}=$t[$i];
}
while(<IN>){
	chomp;
	@t=split;
	$j=$t[0];
	for($k=1;$k<@t;$k++){
		$i=$first{$k};
		$mi12{$i}{$j}=$t[$k]; 
	}
}
close IN;

open IN,"$t1";
<IN>;
while(<IN>){
	chomp;
	@t=split;
	$j=$t[0];
	for($k=1;$k<@t;$k++){
		$i=$first{$k};
		$mi1{$i}{$j}=$t[$k];
		$mi1{$i}{$j}=0 if($mi1{$i}{$j}<0);
	}
}
close IN;

$max=0;

open IN,"$t2";
<IN>;
while(<IN>){
	chomp;
	@t=split;
	$j=$t[0];
	for($k=1;$k<@t;$k++){
		$i=$first{$k};
		$mi2{$i}{$j}=$t[$k];
		$mi2{$i}{$j}=0 if($mi2{$i}{$j}<0);
		$mi{$i}{$j}=$mi12{$i}{$j}-$mi1{$i}{$j}-$mi2{$i}{$j};
		$max=$mi{$i}{$j} if($mi{$i}{$j}>$max);
	}
}
close IN;
	




open OUT,">$s1dir/MI.tmp.xls";
$total_num_of_matrix=0;
for($j=40-$skmer;$j>=$skmer+1;$j--){
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

`cd $s1dir && perl $shdir/create_anova.pl && Rscript $shdir/oneway-anova.R > oneway-anova.out && Rscript $shdir/welchs-anova.R > welchs-anova.out && cd $s1dir/..`;

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
`cd $s1dir && perl $shdir/top_distance.pl > top_distance.xls && cd $s1dir/..`;
`rm $s1dir/MI.tmp2.xls`;
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
print TMP "$total_num_of_matrix\t$cutoff\n";
close TMP;
open OUT,">$output";
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
			
			if($max==0){
				$color="rgb(255,255,255)";
			}else{
				$num=$mi{$i}{$j}/$max;
				$num=1 if($num>1); $num=0 if($num<0);
				$blue1=255-int($num/1*255);
				$green1=255-int($num/1*(255-191));
				$color="rgb(".$blue1.",".$green1.",255)";
			}
		}else{
			print OUT "\t";
			$color="rgb(255,255,255)";
		}
		$svg->rect('x',$x,'y',$y,'width',20,'height',20,'opacity',1,'fill',$color);
	}
	print OUT "\n";
}
close OUT;
$text=$te_pair.": ".$pair_8." ".$skmer."-mers in ".$lkmer."-mer";
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


my $out=$svg->xmlify;
print $out;

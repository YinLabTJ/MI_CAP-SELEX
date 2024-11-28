#!/usr/bin/perl
use File::Spec;
my $cwd=File::Spec->rel2abs(__FILE__);
my ($vol,$shdir,$file)=File::Spec->splitpath($cwd);

$seq=shift; $seqtf1=shift; $seqtf2=shift; $file1_mark=shift; $file2_mark=shift; $pair_8=shift; $pair_barcode=shift; $pair_8s=shift; $lkmer=shift; $skmer=shift; $s1dir=shift; $batch_file=shift;

$datestring = localtime();
print "Iteration of $tf_pair $pair_8 started at $datestring\n";

@t=split /:/,$pair_barcode;
$tf_pair=$t[0]; $barcode=$t[1];

open IN,"$batch_file";
while(<IN>){
	chomp;
	@t=split;
	if($t[0] eq $tf_pair && $t[2] eq $barcode){
		$file_name=$tf_pair."_".$t[2].$t[3];
	}
}
close IN;

$tf1tf2_file="$s1dir/MI.$tf_pair.$pair_8.tf_pair.xls";
$tf1_file="$s1dir/MI.$tf_pair.$pair_8.$file1_mark.xls";
$tf2_file="$s1dir/MI.$tf_pair.$pair_8.$file2_mark.xls";
`rm $s1dir/$pair_8.already_filter` if(-e "$s1dir/$pair_8.already_filter");
$round=0;
$svg12="output/MI_figures/$file_name/$pair_8.svg";
$svg1="output/MI_figures/$file_name/$pair_8.$file1_mark.svg";
$svg2="output/MI_figures/$file_name/$pair_8.$file2_mark.svg";
while(1){
	$round1++;
	print "TF1 Round $round1 Start\n";
	`perl $shdir/step8_top5p_compare_recursively_new.pl $tf1tf2_file $tf1_file $s1dir/$pair_8.distance.txt $s1dir/$pair_8.check.$round1.txt $lkmer $s1dir`;
	open IN,"$s1dir/$pair_8.check.$round1.txt";
	$check=<IN>;
	chomp($check);
	last unless($check==1);
	close IN;
	`perl $shdir/step8_print_high_4mer_pairs.pl $seqtf1 $pair_8 $tf_pair $pair_8s $lkmer $skmer $s1dir $file1_mark $s1dir/$pair_8.distance.txt`;
	`perl $shdir/step8_4mer_pairs_pick_highest_4-mer.pl $s1dir $s1dir/tmp $s1dir/$pair_8.already_filter`;
	`perl $shdir/step8_filter_background_of_individual_TF.pl $seq $pair_8 $tf_pair $pair_8s $lkmer $skmer $s1dir tf_pair filter_tf1.$round1 $s1dir/$pair_8.already_filter > output/MI_figures/$file_name/$pair_8.filter_tf1.$round1.svg`;
	`perl $shdir/step8_filter_background_of_individual_TF.pl $seqtf1 $pair_8 $tf_pair $pair_8s $lkmer $skmer $s1dir $file1_mark filter_tf1.$round1 $s1dir/$pair_8.already_filter > output/MI_figures/$file_name/$pair_8.tf1_filter_tf1.$round1.svg`;
	$svg12.=",output/MI_figures/$file_name/$pair_8.filter_tf1.$round1.svg";
	$svg1.=",output/MI_figures/$file_name/$pair_8.tf1_filter_tf1.$round1.svg";
	$tf1tf2_file="$s1dir/MI.$tf_pair.$pair_8.tf_pair.filter_tf1.$round1.xls";
	$tf1_file="$s1dir/MI.$tf_pair.$pair_8.$file1_mark.filter_tf1.$round1.xls";
}

$round2=0;
while(1){
	$round2++;
	print "TF2 Round $round2 Start\n";
	`perl $shdir/step8_top5p_compare_recursively_new.pl $tf1tf2_file $tf2_file $s1dir/$pair_8.distance.txt $s1dir/$pair_8.check2.$round2.txt $lkmer $s1dir`;
	open IN,"$s1dir/$pair_8.check2.$round2.txt";
	$check=<IN>;
	chomp($check);
	last unless($check==1);
	close IN;
	`perl $shdir/step8_print_high_4mer_pairs.pl $seqtf2 $pair_8 $tf_pair $pair_8s $lkmer $skmer $s1dir $file2_mark $s1dir/$pair_8.distance.txt`;
	`perl $shdir/step8_4mer_pairs_pick_highest_4-mer.pl $s1dir $s1dir/tmp $s1dir/$pair_8.already_filter`;
	`perl $shdir/step8_filter_background_of_individual_TF.pl $seq $pair_8 $tf_pair $pair_8s $lkmer $skmer $s1dir tf_pair filter_tf1_tf2.$round2 $s1dir/$pair_8.already_filter > output/MI_figures/$file_name/$pair_8.filter_tf1_tf2.$round2.svg`;
	`perl $shdir/step8_filter_background_of_individual_TF.pl $seqtf2 $pair_8 $tf_pair $pair_8s $lkmer $skmer $s1dir $file2_mark filter_tf1_tf2.$round2 $s1dir/$pair_8.already_filter > output/MI_figures/$file_name/$pair_8.tf2_filter_tf1_tf2.$round2.svg`;
	$svg12.=",output/MI_figures/$file_name/$pair_8.filter_tf1_tf2.$round2.svg";
	$svg2.=",output/MI_figures/$file_name/$pair_8.tf2_filter_tf1_tf2.$round2.svg";
	$tf1tf2_file="$s1dir/MI.$tf_pair.$pair_8.tf_pair.filter_tf1_tf2.$round2.xls";
	$tf2_file="$s1dir/MI.$tf_pair.$pair_8.$file2_mark.filter_tf1_tf2.$round2.xls";
}

`perl $shdir/step8_top5p_compare_tf1tf2_final.pl $tf1tf2_file $s1dir/$pair_8.final_top5p_distance.xls $lkmer $s1dir`;
if($round1+$round2>2){
	`perl $shdir/step8_svg_merge.pl $svg12 output/MI_figures/$file_name/$pair_8.filter_tf1_tf2.svg`;
}
if($round1>1){
	`perl $shdir/step8_svg_merge.pl $svg1 output/MI_figures/$file_name/$pair_8.tf1_filter_tf1.svg`;
}
if($round2>1){
	`perl $shdir/step8_svg_merge.pl $svg2 output/MI_figures/$file_name/$pair_8.tf2_filter_tf1_tf2.svg`;
}
$datestring = localtime();
print "Iteration of $tf_pair $pair_8 finished at $datestring\n";

use File::Spec;
my $cwd=File::Spec->rel2abs(__FILE__);
my ($vol,$shdir,$file)=File::Spec->splitpath($cwd);

open IN,"output/filter_list";
my $skmer=4; my $distance;
open OUT,">output/top5p.xls";
while(<IN>){
	chomp;
	my @t=split;
	next if(@t>7);
	my $mer1=$t[2]; my $mer2=$t[3];
	my @m1=split /,/,$mer1; my @m2=split /,/,$mer2;
	my @batch=split /,/,$t[6]; $batch[0]=~s/_//g;
	my $group_min=100; my $group_min8=100; my $group_record="";
	foreach my $m1(@m1){
		foreach my $m2(@m2){
			open MI,"output/$t[0]\_$batch[0]/MI.$t[0].$m1\_$m2.tf_pair.xls";
			<MI>;
			my %mi;
			while(<MI>){
				my @m=split;
				my $j=$m[0];
				for(my $i=1;$i<@m;$i++){
					$mi{$i}{$j}=$m[$i];
				}
			}
			close MI;
			open TMP,">MI.tmp5p.xls";
			for(my $j=40-$skmer+1;$j>=$skmer+1;$j--){
				for(my $i=1;$i<=$j-$skmer;$i++){
					$distance=$j-$i;
					if(defined($mi{$i}{$j})){
						print TMP "$distance\t$mi{$i}{$j}";
					}else{
						print TMP "$distance\t-100";
					}
					print TMP "\n" unless($j==$skmer+1 && $i==1);
				}
			}
			close TMP;
			`sort -k2,2rg MI.tmp5p.xls > MI.tmp2.xls`;
			`perl $shdir/top_distance.pl > top_distance.xls`;
			open DIS,"top_distance.xls";
			my $line1=<DIS>;
			chomp($line1);
			my @dis=split /\t/,$line1;
			$group1=$dis[1];
			close DIS;
			open MI,"output/$t[0]\_$batch[0]/MI.$t[0].$m1\_$m2.tf_pair.shift.xls"; 
			<MI>;
			my %ni;
			while(<MI>){
				my @m=split;
				my $j=$m[0];
				for(my $i=1;$i<@m;$i++){
					$ni{$i}{$j}=$m[$i];
				}
			}
			close MI;
			my @mi;
			open TMP,">MI.tmp5p.xls";
			for(my $j=40-$skmer+1;$j>=$skmer+1;$j--){
				for(my $i=1;$i<=$j-$skmer;$i++){
					$distance=$j-$i;
					if(defined($ni{$i}{$j})){
						print TMP "$distance\t$ni{$i}{$j}";
					}else{
						print TMP "$distance\t-100";
					}
					print TMP "\n" unless($j==$skmer+1 && $i==1);
				}
			}
			close TMP;
			`sort -k2,2rg MI.tmp5p.xls > MI.tmp2.xls`;
			`perl $shdir/top_distance.pl > top_distance.xls`;
			open DIS,"top_distance.xls";
			my $line1=<DIS>;
			chomp($line1);
			my @dis=split /\t/,$line1;
			$group2=$dis[1];
			close DIS;
			$group1=100 if(!defined($group1));
			$group2=100 if(!defined($group2));
			my $group=$group1;
			$group=$group2 if($group2>$group);
			$group_record.="," unless($group_record eq "");
			$group_record.=$group."(".$group1.",".$group2.")";
			$group_min=$group if($group_min>$group);
			$group_min8=$group1 if($group_min8>$group1);
		}
	}
	`rm MI.tmp5p.xls MI.tmp2.xls top_distance.xls`;
	print OUT "$t[0]\t$t[1]\t$t[2]\t$t[3]\t$group_min8\t$group_min\t$group_record\n";

}
close IN; close OUT;
`sort -k6,6n output/top5p.xls > output/top5p_sort.xls`;
`rm output/top5p.xls`;

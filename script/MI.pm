sub Huddinge{
	my $te_mer=shift;
	my $combine_mer=shift;
	#print "$mer1\n$mer2\n";
	
	#Substitution
	my @t1=split //,$te_mer;
	$combine_mer=~s/_//;
	my @t2=split //,$combine_mer;
	my $diff_1=0;
	for($isub=0;$isub<@t1;$isub++){
		$diff_1++ if($t1[$isub] ne $t2[$isub]);
	}

	#Shift
	my $diff_2=@t1;
	my $diff_3=@t1;
	for($isub=1;$isub<@t1;$isub++){
		my $sub1=substr($te_mer,$isub,@t1-$isub);
		my $sub2=substr($combine_mer,0,@t1-$isub);
		my @t3=split //,$sub1;
		my @t4=split //,$sub2;
		my $tmp_2=$isub;
		for($jsub=0;$jsub<@t3;$jsub++){
			$tmp_2++ if($t3[$jsub] ne $t4[$jsub]);
		}
		$diff_2=$tmp_2 if($diff_2>$tmp_2);
		my $sub1=substr($te_mer,0,@t1-$isub);
		my $sub2=substr($combine_mer,$isub,@t1-$isub);
		my @t3=split //,$sub1;
		my @t4=split //,$sub2;
		my $tmp_3=$isub;
		for($jsub=0;$jsub<@t3;$jsub++){
			$tmp_3++ if($t3[$jsub] ne $t4[$jsub]);
		}
		$diff_3=$tmp_3 if($diff_3>$tmp_3);
	}
	my $diff=$diff_1;
	$diff=$diff_2 if($diff_2<$diff);
	$diff=$diff_3 if($diff_3<$diff);

	#Gap
	my $half=@t1/2;
	my $sub1=substr($combine_mer,0,$half);	
	my $sub2=substr($combine_mer,$half,$half-1);
	my $sub3=substr($combine_mer,1,$half-1);
	my $sub4=substr($combine_mer,$half,$half);
	my $gap1=$sub1."N".$sub2;
	my $gap2=$sub3."N".$sub4;
	my @t2=split //,$gap1;
	my @t3=split //,$gap2;
	my $diff_4=0; 
	my $diff_5=0;
	for($isub=0;$isub<@t1;$isub++){
		$diff_4++ if($t1[$isub] ne $t2[$isub]);
		$diff_5++ if($t1[$isub] ne $t3[$isub]);
	}

	#return "$mer1\t$mer2\t$diff\t$diff_1\t$diff_2\t$diff_3\n";
	$diff=$diff_4 if($diff_4<$diff);
	$diff=$diff_5 if($diff_5<$diff);
	return "$diff";
}
1;

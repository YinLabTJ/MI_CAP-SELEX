my $svg=shift; my $output=shift;
my @files=split/,/,$svg;
my $x_whole=0; my $y_whole=0;
foreach $file(@files){
	open IN,"$file";
	while(<IN>){
		chomp;
		if(/^\<svg height=\"(\d+)\" width=\"(\d+)\"/){
			$x_whole=$2 if($2>$x_whole);
			$y_whole+=$1;
		}
		next;
	}
	close IN;
}
print "$x_whole\t$y_whole\n";
my $file_num=0; my $y_now=0; my $y_tmp=0;
open OUT,">$output";
foreach $file(@files){
	$file_num++;
	open IN,"$file";
	$line=<IN>; print OUT "$line" if($file_num==1);
	$line=<IN>; print OUT "$line" if($file_num==1);
	$line=<IN>; chomp($line);
	if($line=~/^\<svg height=\"(\d+)\" width=\"(\d+)\"/){
		$y_tmp=$1;
	}
	print OUT "\<svg height=\"$y_whole\" width=\"$x_whole\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:svg=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"\>\n" if($file_num==1);
	print OUT "\<g transform=\"translate(0, $y_now)\"\>\n";
	while(<IN>){
		chomp;
		if(/^\<\/svg\>/){
			print OUT "\<\/g\>\n";
			print OUT "\<\/svg\>\n" if($file_num==@files);
		}else{
			print OUT "$_\n";
		}
	}
	close IN;
	$y_now+=$y_tmp;
}

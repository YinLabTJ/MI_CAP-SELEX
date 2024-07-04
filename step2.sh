mkdir -p pair_tmp_6mer/CEBPD_ATF4
grep local spacek40_out/6mer/CEBPD.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_6mer/CEBPD_ATF4/CEBPD.candidate
grep local spacek40_out/6mer/ATF4.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_6mer/CEBPD_ATF4/ATF4.candidate
grep local spacek40_out/6mer/CEBPD_ATF4.TTACCC40NGCT.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_6mer/CEBPD_ATF4/CEBPD_ATF4.TTACCC40NGCT.candidate
perl step2_filter_reverse_dup.pl pair_tmp_6mer/CEBPD_ATF4/CEBPD_ATF4.TTACCC40NGCT
perl step2_filter_reverse_dup.pl pair_tmp_6mer/CEBPD_ATF4/CEBPD
perl step2_filter_reverse_dup.pl pair_tmp_6mer/CEBPD_ATF4/ATF4
mkdir -p pair_tmp_8mer/CEBPD_ATF4
grep local spacek40_out/8mer/CEBPD.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_8mer/CEBPD_ATF4/CEBPD.candidate
grep local spacek40_out/8mer/ATF4.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_8mer/CEBPD_ATF4/ATF4.candidate
grep local spacek40_out/8mer/CEBPD_ATF4.TTACCC40NGCT.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_8mer/CEBPD_ATF4/CEBPD_ATF4.TTACCC40NGCT.candidate
perl step2_filter_reverse_dup.pl pair_tmp_8mer/CEBPD_ATF4/CEBPD_ATF4.TTACCC40NGCT
perl step2_filter_reverse_dup.pl pair_tmp_8mer/CEBPD_ATF4/CEBPD
perl step2_filter_reverse_dup.pl pair_tmp_8mer/CEBPD_ATF4/ATF4
mkdir -p pair_tmp_6mer/GLIS1_FOXD2
grep local spacek40_out/6mer/GLIS1.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_6mer/GLIS1_FOXD2/GLIS1.candidate
grep local spacek40_out/6mer/FOXD2.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_6mer/GLIS1_FOXD2/FOXD2.candidate
grep local spacek40_out/6mer/GLIS1_FOXD2.TCGCGG40NCAT.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_6mer/GLIS1_FOXD2/GLIS1_FOXD2.TCGCGG40NCAT.candidate
perl step2_filter_reverse_dup.pl pair_tmp_6mer/GLIS1_FOXD2/GLIS1_FOXD2.TCGCGG40NCAT
perl step2_filter_reverse_dup.pl pair_tmp_6mer/GLIS1_FOXD2/GLIS1
perl step2_filter_reverse_dup.pl pair_tmp_6mer/GLIS1_FOXD2/FOXD2
mkdir -p pair_tmp_8mer/GLIS1_FOXD2
grep local spacek40_out/8mer/GLIS1.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_8mer/GLIS1_FOXD2/GLIS1.candidate
grep local spacek40_out/8mer/FOXD2.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_8mer/GLIS1_FOXD2/FOXD2.candidate
grep local spacek40_out/8mer/GLIS1_FOXD2.TCGCGG40NCAT.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_8mer/GLIS1_FOXD2/GLIS1_FOXD2.TCGCGG40NCAT.candidate
perl step2_filter_reverse_dup.pl pair_tmp_8mer/GLIS1_FOXD2/GLIS1_FOXD2.TCGCGG40NCAT
perl step2_filter_reverse_dup.pl pair_tmp_8mer/GLIS1_FOXD2/GLIS1
perl step2_filter_reverse_dup.pl pair_tmp_8mer/GLIS1_FOXD2/FOXD2
mkdir -p pair_tmp_6mer/HES2_FOXD2
grep local spacek40_out/6mer/HES2.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_6mer/HES2_FOXD2/HES2.candidate
grep local spacek40_out/6mer/FOXD2.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_6mer/HES2_FOXD2/FOXD2.candidate
grep local spacek40_out/6mer/HES2_FOXD2.TCCTAG40NATA.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_6mer/HES2_FOXD2/HES2_FOXD2.TCCTAG40NATA.candidate
perl step2_filter_reverse_dup.pl pair_tmp_6mer/HES2_FOXD2/HES2_FOXD2.TCCTAG40NATA
perl step2_filter_reverse_dup.pl pair_tmp_6mer/HES2_FOXD2/HES2
perl step2_filter_reverse_dup.pl pair_tmp_6mer/HES2_FOXD2/FOXD2
mkdir -p pair_tmp_8mer/HES2_FOXD2
grep local spacek40_out/8mer/HES2.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_8mer/HES2_FOXD2/HES2.candidate
grep local spacek40_out/8mer/FOXD2.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_8mer/HES2_FOXD2/FOXD2.candidate
grep local spacek40_out/8mer/HES2_FOXD2.TCCTAG40NATA.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_8mer/HES2_FOXD2/HES2_FOXD2.TCCTAG40NATA.candidate
perl step2_filter_reverse_dup.pl pair_tmp_8mer/HES2_FOXD2/HES2_FOXD2.TCCTAG40NATA
perl step2_filter_reverse_dup.pl pair_tmp_8mer/HES2_FOXD2/HES2
perl step2_filter_reverse_dup.pl pair_tmp_8mer/HES2_FOXD2/FOXD2
mkdir -p pair_tmp_6mer/NR4A2_FOXD2
grep local spacek40_out/6mer/NR4A2.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_6mer/NR4A2_FOXD2/NR4A2.candidate
grep local spacek40_out/6mer/FOXD2.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_6mer/NR4A2_FOXD2/FOXD2.candidate
grep local spacek40_out/6mer/NR4A2_FOXD2.TTTCGC40NGAT.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_6mer/NR4A2_FOXD2/NR4A2_FOXD2.TTTCGC40NGAT.candidate
perl step2_filter_reverse_dup.pl pair_tmp_6mer/NR4A2_FOXD2/NR4A2_FOXD2.TTTCGC40NGAT
perl step2_filter_reverse_dup.pl pair_tmp_6mer/NR4A2_FOXD2/NR4A2
perl step2_filter_reverse_dup.pl pair_tmp_6mer/NR4A2_FOXD2/FOXD2
mkdir -p pair_tmp_8mer/NR4A2_FOXD2
grep local spacek40_out/8mer/NR4A2.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_8mer/NR4A2_FOXD2/NR4A2.candidate
grep local spacek40_out/8mer/FOXD2.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_8mer/NR4A2_FOXD2/FOXD2.candidate
grep local spacek40_out/8mer/NR4A2_FOXD2.TTTCGC40NGAT.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_8mer/NR4A2_FOXD2/NR4A2_FOXD2.TTTCGC40NGAT.candidate
perl step2_filter_reverse_dup.pl pair_tmp_8mer/NR4A2_FOXD2/NR4A2_FOXD2.TTTCGC40NGAT
perl step2_filter_reverse_dup.pl pair_tmp_8mer/NR4A2_FOXD2/NR4A2
perl step2_filter_reverse_dup.pl pair_tmp_8mer/NR4A2_FOXD2/FOXD2
mkdir -p pair_tmp_6mer/ZBED1_FOXD2
grep local spacek40_out/6mer/ZBED1.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_6mer/ZBED1_FOXD2/ZBED1.candidate
grep local spacek40_out/6mer/FOXD2.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_6mer/ZBED1_FOXD2/FOXD2.candidate
grep local spacek40_out/6mer/ZBED1_FOXD2.TTCACT40NATA.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_6mer/ZBED1_FOXD2/ZBED1_FOXD2.TTCACT40NATA.candidate
perl step2_filter_reverse_dup.pl pair_tmp_6mer/ZBED1_FOXD2/ZBED1_FOXD2.TTCACT40NATA
perl step2_filter_reverse_dup.pl pair_tmp_6mer/ZBED1_FOXD2/ZBED1
perl step2_filter_reverse_dup.pl pair_tmp_6mer/ZBED1_FOXD2/FOXD2
mkdir -p pair_tmp_8mer/ZBED1_FOXD2
grep local spacek40_out/8mer/ZBED1.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_8mer/ZBED1_FOXD2/ZBED1.candidate
grep local spacek40_out/8mer/FOXD2.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_8mer/ZBED1_FOXD2/FOXD2.candidate
grep local spacek40_out/8mer/ZBED1_FOXD2.TTCACT40NATA.out | cut -f6,12 | awk '{if($2>1) print $0}' |sort -k2,2rn | head -100 > pair_tmp_8mer/ZBED1_FOXD2/ZBED1_FOXD2.TTCACT40NATA.candidate
perl step2_filter_reverse_dup.pl pair_tmp_8mer/ZBED1_FOXD2/ZBED1_FOXD2.TTCACT40NATA
perl step2_filter_reverse_dup.pl pair_tmp_8mer/ZBED1_FOXD2/ZBED1
perl step2_filter_reverse_dup.pl pair_tmp_8mer/ZBED1_FOXD2/FOXD2

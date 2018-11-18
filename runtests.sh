# /bin/bash

expect=tmp_expected_results
your1=tmp_your_result
your2=tmp_your_result
your3=tmp_your_result
diffttl=test_results

color_def="\e[35m"
color_det="\e[33m"
color_ok="\e[32m"
color_ko="\e[31m"


printf "\e[35mg\e[31mn\e[32ml\e[33m_\e[34mt\e[35me\e[36ms\e[37mt\e[35m\e[31me\e[32mr\e[33mi\e[34mz\e[35me\e[36mr\e[35m\n"
printf "" > $diffttl

onediff() {
	if [ "`diff $1 $2`" = "" ]
	then
		printf $color_ok
		printf "[ok]\n"
	else
		printf $color_ko
		printf "[fail]\n"
		printf $color_det
		diff $1 $2 > "tmp_diff"
		cat -e "tmp_diff"
		echo "Failed test for $1" >> $diffttl
		cat "tmp_diff" >> $diffttl
	fi
}

onetest() { # $1 -> file_name
	printf $color_def
	printf "testing $1...\n"
	cat -e $1 > $expect
	./tests_tiny $1 > $your1
	./tests_small $1 > $your2
	./tests_big $1 > $your3
	onediff $1 $your1;
	onediff $1 $your2;
	onediff $1 $your3;
}

#########################################
###              TESTS                ###
#########################################

printf color_def
printf "SIMPLE TESTS\n"

# single line tests
onetest "testfiles/1l4c.txt"
onetest "testfiles/1l4c_nonl.txt"
onetest "testfiles/1l8c.txt"
onetest "testfiles/1l8c_nonl.txt"
onetest "testfiles/1l16c.txt"
onetest "testfiles/1l16c_nonl.txt"

# two lines tests
onetest "testfiles/2l4c.txt"
onetest "testfiles/2l4c_nonl.txt"
onetest "testfiles/2l8c.txt"
onetest "testfiles/2l8c_nonl.txt"
onetest "testfiles/2l16c.txt"
onetest "testfiles/2l16c_nonl.txt"

# three
onetest "testfiles/3l4c.txt"
onetest "testfiles/3l4c_nonl.txt"
onetest "testfiles/3l8c.txt"
onetest "testfiles/3l8c_nonl.txt"
onetest "testfiles/3l16c.txt"
onetest "testfiles/3l16c_nonl.txt"

# other
onetest "testfiles/0l0c.txt"
onetest "testfiles/multi0.txt"
onetest "testfiles/multi1.txt"
onetest "testfiles/multi2.txt"
onetest "testfiles/multi3.txt"
onetest "testfiles/multi4.txt"
onetest "testfiles/multi5.txt"
onetest "testfiles/multi6.txt"
onetest "testfiles/big_lorem_ipsum.txt"
onetest "testfiles/fat_line.txt"
onetest "testfiles/fat_line_nonl.txt"

printf color_def
printf "ALL TESTS DONE!\n"
rm tmp_*

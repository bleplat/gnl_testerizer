# /bin/bash

expect=tmp_expected_results
your=tmp_your_result
diffttl=test_results

color_def="\e[35m"
color_det="\e[33m"
color_ok="\e[32m"
color_ko="\e[31m"

printf "\e[35mg\e[31mn\e[32ml\e[33m_\e[34mt\e[35me\e[36ms\e[37mt\e[35m\e[31me\e[32mr\e[33mi\e[34mz\e[35me\e[36mr\e[35m\n\n"
printf "" > $diffttl

bonusdiff() {
	if [ "`diff $1 $2`" = "" ]
	then
		printf $color_ok
		printf "[bonus]"
	else
		printf $color_ko
		printf "[no bonus]"
		printf $color_det
		diff $1 $2 > "tmp_diff"
		echo "Failed test for $1" >> $diffttl
		cat "tmp_diff" >> $diffttl
	fi
}

onediff() {
	if [ "`diff $1 $2`" = "" ]
	then
		printf $color_ok
		printf "[ok]"
	else
		printf $color_ko
		printf "[fail]"
		printf $color_det
		diff $1 $2 > "tmp_diff"
		echo "Failed test for $1" >> $diffttl
		cat "tmp_diff" >> $diffttl
	fi
}

onetest() { # $1 -> file_name
	printf $color_def
	printf "testing $1...\n"
	cat $1 | awk 1 > $expect
	# input from file
	./tests_tiny $1 > $your
	onediff $expect $your;
	./tests_small $1 > $your
	onediff $expect $your;
	./tests_big $1 > $your
	onediff $expect $your;
	# standard input
	cat $1 | ./tests_tiny > $your
	onediff $expect $your;
	cat $1 | ./tests_small > $your
	onediff $expect $your;
	cat $1 | ./tests_big > $your
	onediff $expect $your;
	printf "\n\n"
}

testleaks() {
	printf $color_def
	printf "searching leaks with $1...\n"
	pkill tests_leaks > /dev/null
	./tests_leaks $1 &> /dev/null &
	sleep .6
	leaks tests_leaks | grep "total leaked bytes" | sed -e "s/^Process .*: //g" > "tmp_leaks"
	pkill tests_leaks > /dev/null
	sleep .1
	if [ "`cat tmp_leaks`" = "0 leaks for 0 total leaked bytes." ]
	then
		printf $color_ok
		printf "[no leaks]\n\n"
	else
		printf $color_ko
		printf "[leaks!] "
		cat tmp_leaks
		printf "\n"
	fi
}

#########################################
###              TESTS                ###
#########################################

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

# other lines of chars
onetest "testfiles/0l0c.txt"
onetest "testfiles/1l1c.txt"
onetest "testfiles/1l1c_nonl.txt"
onetest "testfiles/3l12c.txt"

# 'multi' files (no waste!)
onetest "testfiles/multi0.txt"
onetest "testfiles/multi1.txt"
onetest "testfiles/multi2.txt"
onetest "testfiles/multi3.txt"
onetest "testfiles/multi4.txt"
onetest "testfiles/multi5.txt"
onetest "testfiles/multi6.txt"

# big files
onetest "testfiles/big_lorem_ipsum.txt"
onetest "testfiles/fat_line.txt"
onetest "testfiles/fat_line_nonl.txt"

# special files
onetest "testfiles/empty_lines.txt"
onetest "testfiles/rn.txt"
onetest "testfiles/protected.txt"

# bad file descriptors
printf $color_def
printf "testing bad file descriptors (lot of tests in one)...\n"
cat "testfiles/badfds_expected" | awk 1 > $expect
./tests_badfds "-" > $your;
onediff $expect $your
printf "\n\n"

# BONUS: multi file descriptors
printf $color_def
printf "testing multi file descriptors bonus (lot of tests in one)...\n"
cat "testfiles/multifd_expected" | awk 1 > $expect
./tests_multifd "-" > $your;
onediff $expect $your
printf "\n\n"

# Leaks tests

testleaks "testfiles/1l4c.txt"
testleaks "testfiles/2l4c.txt"
testleaks "testfiles/2l16c.txt"
testleaks "testfiles/2l16c_nonl.txt"
testleaks "testfiles/0l0l.txt"
testleaks "testfiles/empty_lines.txt"
testleaks "testfiles/fat_line.txt"
testleaks "testfiles/big_lorem_ipsum.txt"
testleaks "file_that_doesnt_existsssss76358638468883"

printf $color_def
printf "ALL TESTS DONE!\n"
rm tmp_*

# /bin/sh

################################################################
### WARNING
### Dont forget to change the path to your project in the Makefile!
####################################################################


expect=tmp_expected_results
your=tmp_your_result
diffttl=test_results

color_def="\e[36m"
color_det="\e[33m"
color_ok="\e[32m"
color_ko="\e[31m"

if [ $1 = "run" ]
then
	printf $color_def
	printf "Running tests without running make!"
else
	printf $color_def
	printf "Making files and running tests...\n"
	make re
	make norminette
fi

printf $color_def
printf "\e[35mg\e[31mn\e[32ml\e[33m_\e[34mt\e[35me\e[36ms\e[37mt\e[35m\e[31me\e[32mr\e[33mi\e[34mz\e[35me\e[36mr\e[35m\n\n"

printf "" > $diffttl

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
		echo "Failed test with $3" >> $diffttl
		cat "tmp_diff" >> $diffttl
	fi
}

onetest() { # $1 -> file_name
	printf $color_def
	printf "testing $1...\n"
	cat $1 | awk 1 > $expect
	# input from file
	./tests_tiny $1 &> $your
	onediff $expect $your $1;
	./tests_small $1 &> $your
	onediff $expect $your $1;
	./tests_big $1 &> $your
	onediff $expect $your $1;
	# standard input
	cat $1 | ./tests_tiny &> $your
	onediff $expect $your $1;
	cat $1 | ./tests_small &> $your
	onediff $expect $your $1;
	cat $1 | ./tests_big &> $your
	onediff $expect $your $1;
	printf "\n\n"
}

testleaks() {
	printf $color_def
	printf "searching leaks with $1...\n"
	pkill tests_leaks &> /dev/null
	./tests_leaks $1 &> /dev/null &
	sleep .6
	leaks tests_leaks | grep "total leaked bytes" | sed -e "s/^Process .*: //g" > "tmp_leaks"
	pkill tests_leaks &> /dev/null
	sleep .1
	if [ "`cat tmp_leaks`" = "0 leaks for 0 total leaked bytes." ]
	then
		printf $color_ok
		printf "[ok]\n\n"
	else
		printf $color_ko
		printf "[leaked] "
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
cat "testfiles/badfdX_expected" | sed "s/X/42/g" | awk 1 > $expect
./tests_badfds "-" "#42" > $your;
onediff $expect $your "Bad file descriptors"
cat "testfiles/badfdX_expected" | sed "s/X/-5/g" | awk 1 > $expect
./tests_badfds "-" "#-5" > $your;
onediff $expect $your "Bad file descriptors"
cat "testfiles/badfdX_expected" | sed "s/X/7777777/g" | awk 1 > $expect
./tests_badfds "-" "#7777777" > $your;
onediff $expect $your "Bad file descriptors"
cat "testfiles/badfds_expected" | awk 1 > $expect
./tests_badfds "-" > $your;
onediff $expect $your "Bad file descriptors"
printf "\n\n"

# NULL pointer
printf $color_def
printf "testing NULL pointer...\n"
cat "testfiles/nullptr_expected" | awk 1 > $expect
./tests_big "-" "#" "testfiles/2l8c.txt" > $your;
onediff $expect $your "NULL pointer"
./tests_tiny "-" "#" "testfiles/unexisting_file7436753645" > $your;
onediff $expect $your "NULL pointer"
printf "\n\n"

# BIG file descriptors
printf $color_def
printf "testing big file descriptors...\n"
cat "testfiles/highfds_expected" | awk 1 > $expect
mkdir -p tmp
./tests_highfds "-" "#128" "testfiles/2l8c.txt" > $your;
onediff $expect $your "Big file descriptor"
./tests_highfds "-" "#512" "testfiles/2l8c.txt" > $your;
onediff $expect $your "Big file descriptor"
./tests_highfds "-" "#2096" "testfiles/2l8c.txt" > $your;
onediff $expect $your "Big file descriptor"
rm -rf tmp
printf "\n\n"

# BONUS: multi file descriptors
printf $color_def
printf "testing multi file descriptors bonus (lot of tests in one)...\n"
cat "testfiles/multifd_expected" | awk 1 > $expect
./tests_multifd "-" > $your;
onediff $expect $your "Multiple file descriptors"
printf "\n\n"

# Leaks tests

testleaks "testfiles/1l4c.txt"
testleaks "testfiles/2l4c.txt"
testleaks "testfiles/2l16c.txt"
testleaks "testfiles/2l16c_nonl.txt"
testleaks "testfiles/0l0l.txt"
testleaks "testfiles/empty_lines.txt"
testleaks "testfiles/fat_line.txt"
testleaks "testfiles/fat_line_nonl.txt"
testleaks "testfiles/big_lorem_ipsum.txt"
testleaks "file_that_doesnt_existsssss76358638468883"

printf $color_def
printf "ALL TESTS DONE!\n"
printf "\e[33mWARNING! This version is not finished and may contains bugs\nTake caution with false positives\n"
rm tmp_*

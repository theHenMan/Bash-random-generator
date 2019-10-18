#!/bin/bash

# Create a new file and write random data to it

# User selects file to write data to; script creates it if it doesn't exist

[ $# != 1 ] && \
	echo "Usage: ./random.gen.sh *filename*" && \
	exit 1

[[ ! -f $1 ]] && \
	touch $1

# Check filesize of the file the data is being written to; max 1MiB
# Exit if filesize requirements are met
if [[ $(wc -c < $1) -gt 1048575 ]]
then
	echo "File size requirements already met"
	ls -lh $1
	exit 0
else
	# I cat /dev/urandom to create the random data
	# then translate (tr) that data to use A-Z, a-z and 0-9
	# use fold to end the line at 15 characters
	# use head to limit the filesize; in this case 1MiB
	# output all the data to a file specified by the user
	# 
	# du -h and ls -lh could be used to see the size of the file(s)
	cat /dev/urandom | tr -dc A-Za-z0-9 | fold -w 15 | head -c 1048576 >> $1
fi

# Sort the file using sort
# Easiest way to sort a file; default is 0-9, then a-z (case insensitive)
# -o option to output to a new file
sort $1 -o sorted.txt

# Remove all lines starting with "A" or "a" and write to a new file
# -i to ignore case
# -v to invert files starting with "a" (thus NOT starting with "a")
# output to new file
grep -i -v ^a sorted.txt > removed_a.txt

# Counting line numbers to determine how many lines were removed
file1=$(wc -l < sorted.txt)
file2=$(wc -l < removed_a.txt)
echo "The number of lines removed were: $(( $file1 - $file2 ))"

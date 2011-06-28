#!/bin/bash

source files.sh

#D_RANGE="100000 500000 1000000"
D_RANGE="1000000"
#Q_RANGE="10000 50000 100000 500000"
Q_RANGE="500000"
I_RANGE="7 15 31 63 127 255 511 1023 2047 4095 8191 16383 32767 65535 131071 262143 524287"

for D in $D_RANGE
do
	for Q in $Q_RANGE
	do
		for I in $I_RANGE
		do
			RT=`$SEQ/bsearch $D $Q $I 1`
			echo "$D,$Q,$I,$RT"
		done
	done
done
		

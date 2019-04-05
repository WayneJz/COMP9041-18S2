#!/usr/bin/perl -w

@arr = ("man", "there", "hey");

foreach $i (reverse 1..$#arr) {
	print "$arr[$i] ";
}

#!/usr/bin/perl -w

# $#ARGV means the last index of ARGV, not length of array.
if ($#ARGV != 1){
    die "Usage: ./echon.pl <number of lines> <string>\n";
}

if ($ARGV[0] !~ /[0-9]/){
    die "./echon.pl: argument 1 must be a non-negative integer\n";
}
elsif ($ARGV[0] < 0){
    die "./echon.pl: argument 1 must be a non-negative integer\n";
} 

for ($i = 0; $i < $ARGV[0]; $i++){
    print "$ARGV[1]\n";
}

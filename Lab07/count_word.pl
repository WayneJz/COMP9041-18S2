#!/usr/bin/perl -w


@content = <STDIN>;

$total = 0;

foreach $line (@content){
    # add boundary to match the exact word
    $count = ($line =~ s/\b$ARGV[0]\b//ig);
    $total += $count;
}

print "$ARGV[0] occurred $total times\n";

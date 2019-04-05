#!/usr/bin/perl -w


@content=<STDIN>;

$total = 0;
foreach $line (@content){
    # count stores the number of matches in line
    $count = ($line =~ s/\W?[a-z]+\W?//ig);
    $total += $count;
}

print "$total words\n";

#!/usr/bin/perl -w


$freq = $ARGV[0];
@word = <STDIN>;
%wordfreq = ();

foreach $line (@word){
    $wordfreq{$line} += 1;
    if ($wordfreq{$line} == $freq){
        print "Snap: $line";
        last;
    }
}

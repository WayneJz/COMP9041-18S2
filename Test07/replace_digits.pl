#!/usr/bin/perl -w


open F, '<', "$ARGV[0]" or die "$ARGV[0] does not exist";
@content = <F>;
close F;

foreach $line (@content){
    $line =~ s/\d/#/g;
}

open N, '>', "$ARGV[0]" or die "$ARGV[0] writting permission denied";
foreach $newline (@content){
    print N "$newline";
}
close N;

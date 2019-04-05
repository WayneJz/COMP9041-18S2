#!/usr/bin/perl -w

@str = <STDIN>;
foreach $line (@str) {
    $line =~ tr /0-4/</;
    $line =~ tr /6-9/>/;
    print $line;
}


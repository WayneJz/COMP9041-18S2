#!/usr/bin/perl -w


@occurrence = ();

foreach $word (@ARGV){
    $occur = 0;
    foreach $ocrword (@occurrence){
        $occur = 1 if ($ocrword eq $word);
    }
    print "$word " if ($occur == 0);
    push @occurrence, $word;
}
print "\n";

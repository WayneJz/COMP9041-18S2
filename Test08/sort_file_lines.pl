#!/usr/bin/perl -w


open F, '<', "$ARGV[0]" or die "cannot open file $ARGV[0]!\n";
@content = <F>;
close F;

%linelength = ();

foreach $line (@content){
    $linelength{$line} = length($line);
}

# sort by value length comparison, if equal, sort by key (by default alphabetical order)
foreach $k (sort{ ($linelength{$a} <=> $linelength{$b}) or ($a cmp $b) } keys %linelength) {
    print "$k";
}

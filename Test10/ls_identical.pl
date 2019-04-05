#!/usr/bin/perl -w

use File::Compare;
use File::Basename;

foreach my $file (glob "$ARGV[0]/*"){
    my $bsfile = basename($file);
    if ( -e "$ARGV[1]/$bsfile" && compare("$file", "$ARGV[1]/$bsfile") == 0){
        print "$bsfile\n";
    }
}

#!/usr/bin/perl -w


open F, '<', "$ARGV[0]" or die "cannot open $ARGV[0]\n";
my $total = 0;
foreach $line (<F>){
    if ($line =~ /\$(\d+\.\d+)/){
        $total += $1;
    }
}

printf "\$%.2f\n", $total;

#!/usr/bin/perl -w


open F, '<', $ARGV[1] or die "cannot open $ARGV[1]\n";
my @content = <F>;
close F;

my $sum = 0;

foreach my $line (@content){
    if ($line =~ /"how_many": (\d+),/){
        $temp = $1;
    }
    if ($line =~ /"species": "(.*)"/){
        my $species = $1;
        if ( $species eq $ARGV[0]){
            $sum += $temp;
            $temp = 0;
        }
        else{
            $temp = 0;
        }
    }   
}

print "$sum\n";

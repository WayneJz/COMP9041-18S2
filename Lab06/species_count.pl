#!/usr/bin/perl -w


open FILE, '<', $ARGV[1] or die "Cannot open file\n";
@content = <FILE>;
close FILE;

$pod = 0;
$count = 0;

foreach $line (@content){
    if ($line =~ /$ARGV[0]/){
        $pod += 1;
        $line =~ /\d{2}\/\d{2}\/\d{2}\s*(\d+)/;
        $count += $1;
    }
}

print "$ARGV[0] observations: $pod pods, $count individuals\n";

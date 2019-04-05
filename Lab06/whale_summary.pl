#!/usr/bin/perl -w

open FILE, '<', $ARGV[0] or die "Cannot open file\n";
@content = <FILE>;
close FILE;

%pod = ();
%count = ();

foreach $line (@content){
    $line =~ /^\d{2}\/\d{2}\/\d{2}\s*(\d+)\s*(\S+.*)$/;
    my $name = $2;
    my $amount = $1;
    $name =~ tr/A-Z/a-z/;
    $name =~ s/\s+/ /g;
    $name =~ s/\s*$//;
    $name =~ s/s$//;
    $pod{$name} += 1;
    $count{$name} += $amount;
}

foreach $m (sort keys %pod){
    print "$m observations: $pod{$m} pods, $count{$m} individuals\n";
}


#!/usr/bin/perl -w


open FILE, '<', $ARGV[0] or die "Cannot open $ARGV[0]!";
@data = <FILE>;
close FILE;

$report = 0;

for ($i = 0; $i < @data; $i++){
    if ($data[$i] =~ /\d{2}\/\d{2}\/\d{2}\s*(\d+)\s*Orca/){
        $report += $1;
    }
}

print "$report Orcas reported in $ARGV[0]\n";


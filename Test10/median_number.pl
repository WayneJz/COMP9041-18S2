#!/usr/bin/perl -w

my $numcount = $#ARGV / 2;
my $i = 0;

# must use sort {$a <=> $b} otherwise compare based on first digit
# e.g. 1 < 222 < 3
my @num = (sort{$a <=> $b} @ARGV);

while ($i < @num){
    if ($i == $numcount){
        print "$num[$i]\n";
    }
    $i += 1;
}

    

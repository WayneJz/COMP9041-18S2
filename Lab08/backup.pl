#!/usr/bin/perl -w


open F, '<', "$ARGV[0]" or die "$ARGV[0] does not exist!\n";

$suffix=0;
while ( -f ".$ARGV[0].$suffix" ){
    $suffix += 1;
}

open BF, '>', ".$ARGV[0].$suffix";
print BF <F>;
close F;
close BF;

print "Backup of '$ARGV[0]' saved as '.$ARGV[0].$suffix'\n";

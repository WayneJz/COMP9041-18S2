#!/usr/bin/perl -w


open F, '<', "$ARGV[1]" or die;
@content = <F>;
close F;

for($i = 0; $i < @content; $i++){
    if ($i == $ARGV[0]-1){
        print "$content[$i]";
    }
}

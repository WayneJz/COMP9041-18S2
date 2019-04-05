#!/usr/bin/perl -w


foreach $file (glob "lyrics/*.txt"){
    open F, '<', $file or die "$file does not exist\n";
    @content = <F>;
    close F;
    
    $wtotal = 0;
    $ttotal = 0;
    foreach $line (@content){
        $linecp = $line;
        $wcount = ($line =~ s/\b$ARGV[0]\b//ig);
        $tcount = ($linecp =~ s/\W?[a-z]+\W?//ig);
        $wtotal += $wcount;
        $ttotal += $tcount;
    }
    $ratio = log(($wtotal+1)/$ttotal);
    $file =~ s/^.*\///g;
    $file =~ s/\.txt$//ig;
    $file =~ s/_/ /g;    
    printf "log((%d+1)/%6d) = %8.4f %s\n",$wtotal,$ttotal,$ratio,$file; 
}

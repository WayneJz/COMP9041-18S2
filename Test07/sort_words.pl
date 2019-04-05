#!/usr/bin/perl -w


@content = <STDIN>;

foreach $line (@content){
    @wordarr = split (/\s+/, $line);
    @wordarr = sort (@wordarr);
    print "@wordarr\n";
}

#!/usr/bin/perl -w

use File::Copy;
use File::Basename;

if ($ARGV[0] eq 'save' || $ARGV[0] eq 'load'){
    $suffix = 0;
    # -d means if directory exists
    while ( -d ".snapshot.$suffix" ){
        $suffix += 1;
    }
    $newdir = ".snapshot.$suffix";
    mkdir "$newdir";
    # glob "*" includes all non-hidden files
    # do NOT use glob ".*", it indicates all hidden files (start at ".")
    foreach $file (glob "*") {
        next if ($file =~ /snapshot\.pl/);
        next if ($file =~ /^\./);
        copy("$file","$newdir/$file") or die "copying $file failed!\n";
    }
    print "Creating snapshot $suffix\n";
}

if ($ARGV[0] eq 'load'){
    # delete all non-hidden files in current dir (except this) before restore
    foreach $file (glob "*") {
        next if ($file =~ /snapshot\.pl/);
        next if ($file =~ /^\./);
        # unlink is same as rm in shell
        unlink $file;
    }

    foreach $file (glob ".snapshot.$ARGV[1]/*"){
        $rfile = basename("$file");
        copy("$file","$rfile") or die "copying $file failed!\n";
    }
    print "Restoring snapshot $ARGV[1]\n";
}


    

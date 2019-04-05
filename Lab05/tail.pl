#!/usr/bin/perl -w

# if argument exist and first argument is negative int
if (@ARGV > 0 && $ARGV[0] =~ /-\d{1,}/){
    $ARGV[0] =~ tr/-//d;
    $N = $ARGV[0];
    shift @ARGV;
}
# by default output 10 lines
else {
    $N = 10;
}

# after shift if argument does not exist, use stdin
if (@ARGV <= 0){
    @content = <STDIN>;
    while (@content > $N){
        shift @content;
    }
    foreach $line (@content){
        print "$line";
    }
}

# after shift if argument exists, open file
else {
    foreach $file (@ARGV){
        if (! -r $file){
            die "./tail.pl: can't open $file\n"
        }
        open IN, '<', $file;
        @content = <IN>;
        close IN;

        # if content greater than indicated number, do shift
        while (@content > $N){
            shift @content;
        }
        
        # if more than one file, separate them
        if (@ARGV > 1){
            print "==> $file <==\n";
        }
        foreach $line (@content){
            print "$line";
        }
    }
}

    
    


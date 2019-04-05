#!/usr/bin/perl -w


$url_u = "http://www.handbook.unsw.edu.au/undergraduate/courses/2018/$ARGV[0].html";
$url_p = "http://www.handbook.unsw.edu.au/postgraduate/courses/2018/$ARGV[0].html";
open P, "wget -q -O- $url_p|";
open U, "wget -q -O- $url_u|";

@pre=();

while ($line = <P>) {
    # Some course shows 'Prerequisite', others show 'Prerequisites' (with tailing s)
    if ($line =~ /Prerequisites*:/){
        # As "Excluded courses" is in the same line, any content after the tags to be deleted
        $line =~ s/<\/p>.*//g;
        # Extract one course at one time, then delete it, until no course at the line
        while ($line =~ /(\w{4}\d{4})/){
            push (@pre, $1);
            $line =~ s/\w{4}\d{4}//;
        }
    }
}

while ($line = <U>) {
    if ($line =~ /Prerequisites*:/){
        $line =~ s/<\/p>.*//g;
        while ($line =~ /(\w{4}\d{4})/){
            push (@pre, $1);
            $line =~ s/\w{4}\d{4}//;
        }
    }
}

foreach $course (sort @pre){
    print "$course\n";
}



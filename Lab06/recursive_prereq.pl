#!/usr/bin/perl -w


#rec_pre used for recursion, push and pop, when empty, recursion stops
#pre used for record, only push(append) the prerequisites

@rec_pre=();
@pre=();

# can handle both '-r' or not situation
if (@ARGV > 1){
    push(@rec_pre, $ARGV[1]);
}
else{
    push(@rec_pre, $ARGV[0]);
}


while (@rec_pre > 0){
    
    $url_u = "http://www.handbook.unsw.edu.au/undergraduate/courses/2018/$rec_pre[-1].html";
    $url_p = "http://www.handbook.unsw.edu.au/postgraduate/courses/2018/$rec_pre[-1].html";
    open P, "wget -q -O- $url_p|";
    open U, "wget -q -O- $url_u|";
    # only pop out rec_pre array, if empty, recursion is completed
    # pre array is for recording the result
    pop(@rec_pre);


    while ($line = <P>) {
        # Some course shows 'Prerequisite', others show 'Prerequisites' (with tailing s)
        if ($line =~ /Prerequisites*:/){
            # As "Excluded courses" is in the same line, any content after the tags to be deleted
            $line =~ s/<\/p>.*//g;
            # Extract one course at one time, then delete it, until no course at the line
            while ($line =~ /(\w{4}\d{4})/){
                # push into two arrays
                push (@pre, $1);
                push (@rec_pre, $1);
                $line =~ s/\w{4}\d{4}//;
            }
        }
    }

    while ($line = <U>) {
        if ($line =~ /Prerequisites*:/){
            $line =~ s/<\/p>.*//g;
            while ($line =~ /(\w{4}\d{4})/){
                push (@pre, $1);
                push (@rec_pre, $1);
                $line =~ s/\w{4}\d{4}//;
            }
        }
    }
}

$previous_course = '';

foreach $course (sort @pre){
    # As sorted, duplicates next to each other, then eliminate duplicates
    if ($course ne $previous_course){
        print "$course\n";
    }
    $previous_course = $course;
}

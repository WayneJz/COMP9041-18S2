#!/usr/bin/perl -w

@file = <STDIN>;

# initialize a sequence array
@randint = ();
while (@randint <= $#file) {
    $randi = int(rand($#file + 1));
    # avoid repeated numbers
    if (grep { $_ eq $randi} @randint){
        next;
    }
    else {
        push(@randint, $randi);
    }
}

for ($i = 0; $i < @randint; $i++){
    print "$file[$randint[$i]]";
}

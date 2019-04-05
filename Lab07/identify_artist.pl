#!/usr/bin/perl -w

if ($ARGV[0] eq '-d'){
    shift(@ARGV);
    $debug = 1;
}
else{
    $debug = 0;
}

sub artist_seek{
    my $sign = $_[0];
    # local variable hash table does not influence returning it to main
    my %frequency = ();
    foreach my $file (glob "lyrics/*.txt"){
        open F, '<', $file or die "$file does not exist\n";
        my @content = <F>;
        close F;
        
        my $wtotal = 0;
        my $ttotal = 0;
        foreach $line (@content){
            $linecp = $line;
            $wcount = ($line =~ s/\b$sign\b//ig);
            $tcount = ($linecp =~ s/\W?[a-z]+\W?//ig);
            $wtotal += $wcount;
            $ttotal += $tcount;
        }
        my $ratio = log(($wtotal+1)/$ttotal);
        $file =~ s/^.*\///g;
        $file =~ s/\.txt$//ig;
        $file =~ s/_/ /g;

        # in debug mode, print probability of every word compared to each artist
        if ($debug == 1){
            printf "$sign is log((%d+1)/%6d) = %8.4f %s\n",$wtotal,$ttotal,$ratio,$file;
        }
        $frequency{$file} = $ratio;
    }
    # DO NOT return a reference (i.e. \%frequency), as catcher in main is a hash table
    return %frequency;
}



foreach my $song (@ARGV){
    open S, '<', $song or die "$song does not exist\n";
    my @test = <S>;
    close S;
    # store probalility of every word of this song compared to artists
    %art_pro = ();

    foreach my $songline (@test){
        # use the non-word sign to split single words
        my @slarray = split (/\W+/i, $songline);
        
        foreach my $word (@slarray){
            # initialize a hash table to catch the hash table returned from sub
            # store probalility of a single word compared to artists
            my %word_pro = artist_seek($word);

            # to sum up the probability of every word for each artists(key)
            foreach my $i (keys %word_pro){
                $art_pro{$i} += $word_pro{$i};
            }
        }
    }
    if ($debug == 1){
        foreach my $k (reverse sort{$art_pro{$a} <=> $art_pro{$b}} keys %art_pro){
            printf "$song: log_probability of %.1f for $k\n", $art_pro{$k};
        }
    }

    foreach my $k (reverse sort{$art_pro{$a} <=> $art_pro{$b}} keys %art_pro){
        printf "$song most resembles the work of $k (log-probability=%.1f)\n", $art_pro{$k};
        last;
    }
    
}

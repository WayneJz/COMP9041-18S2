#!/usr/bin/perl -w


@content = <STDIN>;
@cpcontent = @content;


%num = ();
@numofall = ();
$lineseq = 0;

foreach $line (@content){
    $lineseq += 1;
    #$line =~ s/[^\d\-\. ]//g;
    #$line =~ s/(\d)\-{2,}/$1/g;
    #$line =~ s/\-{2,}/-/g;
    
    #perl can automatically handle .5 -.5 numbers
    #then above is useless
    @linenum = ();
    while ($line =~ /(\-?\d*\.?\d+)/){
        push @linenum, $1;
        $line =~ s/$1//;
    }
    if (@linenum > 0){
        my $linemax = (reverse sort{$a <=> $b} @linenum)[0];
        push @numofall, $linemax;
        $num{$lineseq} = $linemax;
    }
}

if (@numofall > 0){
    $allmax = (reverse sort{$a <=> $b} @numofall)[0];
    foreach $k (sort keys %num){
        if ($num{$k} == $allmax){
            $lineseq = 0;
            foreach $line (@cpcontent){
                $lineseq += 1;
                print "$line" if ($k == $lineseq);
            }
        }
    }
}


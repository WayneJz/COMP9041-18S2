#!/usr/bin/perl -w


open F, '<', "$ARGV[0]" or die "cannot open $ARGV[0]\n";
@content = <F>;
close F;

$numline = 0;
@printline = ();

foreach my $line (@content){
    $numline += 1;
}

if ($numline % 2 == 0){
    push @printline, $numline / 2;
    push @printline, $numline / 2 + 1;
}
else{
    push @printline, $numline / 2 + 0.5;
}

foreach my $pline (@printline){
    $clinenum = 0;
    foreach my $cline (@content){
        $clinenum += 1;
        print "$cline" if ($clinenum == $pline);
    }
}


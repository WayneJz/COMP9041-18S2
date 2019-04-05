#!/usr/bin/perl -w


open F, '<', "$ARGV[0]" or die "cannot open $ARGV[0]\n";
@content = <F>;
close F;

foreach $line (@content){
    
    # continue if comment, change the interpreter comment
    if ($line =~ /^#/){
        $line =~ s/(#!).*/$1\/usr\/bin\/perl -w/g;
        next;
    }

    # delete line breaks for adding symbols
    $line =~ s/[\n\r]//g;

    # change echo lines and continue
    if ($line =~ /\becho\b/){
        $line =~ s/echo (.*)/print "$1\\n";/g;
        $line = "$line\n";
        next;
    }

    # convert condition control or calculation to single bracket
    if ($line =~ /\$\(\(/){
        $line =~ s/\$\(\(/ /g;
        $line =~ s/\)\)//g;
    }
    else{
        $line =~ s/\(\(/(/g;
        $line =~ s/\)\)/)/g;
    }

    # convert variables before or after operators to dollar variables
    $line =~ s/([a-zA-Z_]+)\s?([\+|\-|\*|\/|=|>=|<=|==|>|<])/\$$1 $2/g;
    $line =~ s/([\+|\-|\*|\/|=|>=|<=|==|>|<])\s?([a-zA-Z_]+)/$1 \$$2/g;
    
    # add blanks between operators and digits 
    $line =~ s/(=)(\d+)/$1 $2/g;

    # convert done and do
    $line =~ s/\bdone\b/}/g;
    $line =~ s/\bfi\b/}/g;
    $line =~ s/\bdo\b//g;
    $line =~ s/\bthen\b//g;

    if ($line =~ /\bwhile\b/){
        $line = "$line\{";
    }
    elsif ($line =~ /\bif\b/){
        $line = "$line\{";
    }
    elsif ($line ne '}' && $line ne ''){
        $line = "$line\;";
    }
    $line = "$line\n";
}

foreach $line (@content){
    print "$line" if ($line ne "\n");
}

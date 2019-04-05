#!/usr/bin/perl -w

if (@ARGV == 0){
    print "Usage: ./identical_files.pl <files>\n";
    exit 1;
}


@content = ();

foreach $file (@ARGV){
    open F, '<', "$file" or die "$file does not exist";
    @newcontent = <F>;
    close F;
    if (@content){
        $i = 0;
        if (!@newcontent){
            print "$file is not identical\n";
            exit 1;
        }
        # if cannot ensure each file in same length, use while instead of for loop
        while ($i < @content && $i < @newcontent){
            if ($content[$i] ne $newcontent[$i] || $#content != $#newcontent){
                print "$file is not identical\n";
                exit 1;
            }
            $i++;
        }
    }
    @content = @newcontent;
}
print "All files are identical\n";
        

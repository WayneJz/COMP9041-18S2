#!/usr/bin/perl -w

print "#!/usr/bin/perl -w\n\n";
print "print \"";
foreach $word (split //, $ARGV[0]) {
    printf "\\x%02x", ord($word);
}
print "\\n\";\n";

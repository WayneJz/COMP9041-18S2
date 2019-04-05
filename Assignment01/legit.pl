#!/usr/bin/perl -w

# Written by Zhou JIANG, z5146092

use File::Copy;
use File::Basename;
use File::Compare;
use File::Path;

$legitdir = '.legit';
$indexdir = "$legitdir/filearcv";

# Subset 0

# Function 1: init
# initializing a hidden folder for init

sub init{
    if( -d "$legitdir"){
        print "legit.pl: error: $legitdir already exists\n";
        exit 1;
    }
    else{
        mkdir "$legitdir";
        open F, '>', "$legitdir/.BRANCHINFO";
        print F "MASTERY:master";
        close F;
        print "Initialized empty legit repository in $legitdir\n";
    }
}


# Sub-function 0: legit directory checking
# USED BY MAIN SWITCH

sub legitcheck{
    (my $option) = @_;

    if ( ! -d "$legitdir"){
        print "legit.pl: error: no $legitdir directory containing legit repository exists\n";
        exit 1;
    }
    elsif ($option == 2 && -d "$legitdir" && &commitseq(2) < 0){
        print "legit.pl: error: your repository does not have any commits yet\n";
        exit 1;
    }
}


# Function 2: add
# indexdir is a folder which temporarily store the added files before commit
# UPDATE: can be used for "commit -a -m" option, updating content of files in the index before commit
# UPDATE: if adding a previous file that has been deleted, delete it in index dir as well
# ALSO USED BY MERGE

sub add{
    my (@filearr) = @_; 

    if (! -d "$indexdir"){
        mkdir "$indexdir";
    }

    my $lastcommit = &commitseq(2);

    foreach my $file (@filearr){
        # check if filename contains illegal characters or starts with non-alphanumeric character
        if ($file =~ /[^_a-zA-Z0-9\.\-]/ or $file =~ /^[^a-zA-Z0-9]/){
            print "legit.pl: error: invalid filename '$file'\n";
            exit 1;
        }
        elsif ((! -e "$file") && (! -e "$legitdir/.commit.$lastcommit/$file")){
            print "legit.pl: error: can not open '$file'\n";
            exit 1;
        }
    }

    foreach my $file (@filearr){
        # if file has been removed in working dir, remove in index dir as well
        if ((! -e "$file") && ( -e "$legitdir/.commit.$lastcommit/$file")){
            unlink "$indexdir/$file";
        }
        else{
            copy("$file","$indexdir/$file") or die "add : copying $file failed!\n";
        }
    }
}


# Sub-function 1: new commit/last commit sequence
# have 2 options to find the sequence num of last commit, or generate a new sequence num to commit
# USED BY LEGITCHECK, ADD, COMMIT, STATUS, BRANCH, MAIN SWITCH

sub commitseq{
    my ($option) = @_;
    my $suffix = 0;

    while ( -d "$legitdir/.commit.$suffix" ){
        $suffix += 1;
    }
    my $presuffix = $suffix - 1;

    return $suffix if ($option == 1);
    return $presuffix if ($option == 2);
}


# Sub-function 2: file compare
# have 3 options comparing between last commit, index dir and working dir 
# USED BY COMMIT, RM (RMCHECK), STATUS

sub filecompare{
    (my $filename, $cmpoption) = @_;
    
    if (-d "$legitdir/.commit.0"){
        $presuffix = (reverse sort &readbranch(2))[0] ;
    }
    else{
        $presuffix = -1;
    }

    my $predir = "$legitdir/.commit.$presuffix";
    my $filecmp = 0;

    # option 1.1 : compare ALL files between last commit and index dir (used by commit)
    # if at least one file is different, then filecmp = 1, otherwise files are all the same filecmp = 0
    # if presuffix >= 0 means previous commit exists
    
    if ($cmpoption == 1 && $presuffix >= 0){
        foreach my $prefile (glob "$predir/*"){
            my $bsprefile = basename($prefile);
            if ( -e "$indexdir/$bsprefile"){
                if (compare("$indexdir/$bsprefile","$prefile") == 1){
                    $filecmp = 1;
                    last;
                }
            }
            else{
                $filecmp = 1;
                last;
            }
        }
        foreach my $indexfile (glob "$indexdir/*"){
            my $bsindexfile = basename($indexfile);
            if ( -e "$predir/$bsindexfile"){
                if (compare("$predir/$bsindexfile","$indexfile") == 1){
                    $filecmp = 1;
                    last;
                }
            }
            else{
                $filecmp = 1;
                last;
            }
        }
    }
    # option 1.2 : if no previous commit, same as different, filecmp set to 1 (used by commit)
    elsif ($cmpoption == 1 && $presuffix < 0){
        $filecmp = 1;
    }

    # option 2: compare specified file between working dir and index dir (used by rm, status)
    elsif ($cmpoption == 2){
        if ( -e "$indexdir/$filename"){
            $filecmp = 1 if (compare("$indexdir/$filename","$filename") == 1);
        }
        # if file cannot be found in index dir
        else{
            return 2;
        }
    }

    # option 3: compare specified file between working dir and last commit (used by rm, status)
    elsif ($cmpoption == 3){
        if ( -e "$predir/$filename"){
            $filecmp = 1 if (compare("$predir/$filename","$filename") == 1);
        }
        # if file cannot be found in commit repository
        else{
            return 2;
        }
    }

    # option 4: compare specified file between index dir and last commit (used by rm, status)
    elsif ($cmpoption == 4){
        if ( -e "$predir/$filename" && -e "$indexdir/$filename"){
            $filecmp = 1 if (compare("$predir/$filename","$indexdir/$filename") == 1);
        }
        # if file cannot be found in commit repository or index dir
        else{
            return 2;
        }
    }
    return 0 if ($filecmp == 0);
    return 1 if ($filecmp == 1);
}


# Sub-function 3: open legit directory
# return any sub-directories in .legit
# USED BY LOG, SHOW, BRANCH

sub opensub{
    opendir(DIR, "$legitdir") or die "cannot open directory $legitdir\n";
    my @subdir = readdir(DIR);
    closedir DIR;
    return @subdir;
}


# Sub-function 4: read current branch
# have 2 options : return current branch that users checkout, or any commits belong to current branch
# USED BY FILECOMPARE, COMMIT, LOG, BRANCH, CHECKOUT, MERGE, LOGUPDATE

sub readbranch{
    my ($option) = @_;
    my $mastery = '';

    # option 1: return the branch name users are currently in
    open F, '<', "$legitdir/.BRANCHINFO";
    foreach my $line (<F>){
        if ($line =~ /MASTERY:(.*)/){
            $mastery = $1;
            return $mastery if ($option == 1);
        }
    }
    close F;

    my @branchcommit = ();

    # option 3: return all the commits of the master branch
    if ($option == 3){
        $mastery = 'master';
    }
    
    # option 2: return all the commits of the branch which users are currently in
    open B, '<', "$legitdir/branch.$mastery" or die "cannot open $legitdir/branch.$mastery!\n";
    foreach my $line (<B>){
        if ($line =~ /COMMIT:(\d+)/){
            push @branchcommit, $1;
        }
    }
    close B;
    return @branchcommit if ($option == 2 || $option == 3);
}


# Sub-function 4: read specified branch
# return all the commits of the specified branch
# USED BY BRANCH, CHECKOUT, MERGE, LOGUPDATE

sub readspcbranch{
    (my $branchname) = @_;
    my @branchcommit = ();

    open B, '<', "$legitdir/branch.$branchname" or die "cannot open $legitdir/branch.$branchname!\n";
    foreach my $line (<B>){
        if ($line =~ /COMMIT:(\d+)/){
            push @branchcommit, $1;
        }
    }
    close B;
    return @branchcommit;
}


# Function 3: commit
# copy all files from filearcv to repository, repository numbers are unique for each commit
# ALSO USED BY MERGE

sub commit{
    # Must use brackets to receive arguments
    my ($message) = @_;
    my $suffix = &commitseq(1);

    # check if the previous commit is same as the content in index directory
    # calls the compare function
    if (&filecompare('all', 1) == 0){
        print "nothing to commit\n";
        return;
    }

    my $comdir = "$legitdir/.commit.$suffix";
    mkdir "$comdir";

    foreach my $file (glob "$indexdir/*") {
        my $bsfile = basename("$file");
        next if ($bsfile =~ /^\./);
        copy("$file","$comdir/$bsfile") or die "commit : copying $file failed!\n";
    }

    open M, '>', "$comdir/.message";
    print M "$message";
    close M;

    my $branch = &readbranch(1);

    open F, '>>', "$legitdir/branch.$branch";
    print F "COMMIT:$suffix\n";
    close F;

    print "Committed as commit $suffix\n";
}


# Function 4: log
# display number and message of each repository

sub log{
    # open .legit directory and read all sub-directories
    my @subdir = &opensub();

    # get all commit numbers belongs to current branch
    my @branchcommit = &readbranch(2);

    # reverse sort is to display commit number in newest-first order
    foreach $commitnum (reverse sort @branchcommit){
        foreach $folder (@subdir){
            if ($folder =~ /\.commit\.$commitnum/){
                open F, '<', "$legitdir/$folder/.message" or die "cannot find message file in $folder\n";
                my @msgcontent = <F>;
                close F;
                print "$commitnum @msgcontent\n";
            }
        }
    }
}


# Function 5: show
# display content of file which indicated by commit number and filename
# if not commit number (shows '-1'), display the file in the index directory

sub show{
    (my $commitnum, my $filename) = @_;
    my $hascommit = 0;

    my @subdir = &opensub();

    # situation 1: check if commit exists, display file in indicated directory
    # if commit number not given, commitnum shows '-1', no matches in this part
    foreach $folder (@subdir){
        if ($folder =~ /\.commit\.(\d+)/){
            $hascommit = 1;
            if ($folder =~ /\.commit\.$commitnum/){
                if (! -e "$legitdir/$folder/$filename"){
                    print "legit.pl: error: '$filename' not found in commit $commitnum\n";
                    exit 1;
                }
                open F, '<', "$legitdir/$folder/$filename";
                print <F>;
                close F;
                return;
            }
        }
    }
    # situation 2: display file in the index if has committed at least once
    if ($commitnum == -1 && $hascommit == 1){
        if (! -e "$indexdir/$filename"){
            print "legit.pl: error: '$filename' not found in index\n";
            exit 1;
        }
        open F, '<', "$indexdir/$filename";
        print <F>;
        close F;
        return;
    }
    # situation 4: commit number is wrong, error prompted
    # no matches at all above parts (does not match directory number, nor match '-1')
    else{
        print "legit.pl: error: unknown commit '$commitnum'\n";
        exit 1;
    }
}


# Subset 1

# Function 6: rm (remove specified filename)
# check if file can be removed, avoid users mistakes
# UPDATE: separated with two functions, one is checking for legal remove, another do removals

sub rmcheck{
    (my $filename, my $option) = @_;

    if ($filename =~ /\-/){
        print "usage: legit.pl rm [--force] [--cached] <filenames>\n";
        exit 1;
    }


    # check if no 'force' argument specified
    if ($option eq 'n' || $option eq 'c'){

        # situation 1: if file in index dir differs from working dir and last commit 
        if (&filecompare($filename, 2) == 1 && &filecompare($filename, 4) == 1){
            print "legit.pl: error: '$filename' in index is different to both working file and repository\n";
            exit 1;
        }
        if ($option eq 'n'){

            # situation 2: if file in index dir same as working dir, but has not commit, or differs from last commit 
            if (&filecompare($filename, 2) == 0 && (&filecompare($filename, 4) == 1 or &filecompare($filename, 3) == 2)){
                print "legit.pl: error: '$filename' has changes staged in the index\n";
                exit 1;
            }

            # situation 3: if file in working dir differs from last commit, and has not been added into index dir  
            elsif (&filecompare($filename, 3) == 1 && &filecompare($filename, 4) == 0){
                print "legit.pl: error: '$filename' in repository is different to working file\n";
                exit 1;
            }
        }
    }

    # situation 4: if file cannot found in index dir
    if (&filecompare($filename, 2) == 2){
        print "legit.pl: error: '$filename' is not in the legit repository\n";
        exit 1;
    }
}

sub rm{
    (my $filename, my $option) = @_;

    # if no 'cached' option specified, delete file from working directory
    if ($option eq 'n' || $option eq 'f'){
        foreach my $file (glob "*"){
            if (basename($file) eq $filename){
                unlink $file;
                last;
            }
        }
    }

    # delete file from index directory
    foreach my $file (glob "$indexdir/*"){
        if (basename($file) eq $filename){
            unlink $file;
            last;
        }
    }
}


# Function 7: show status of all files from working dir, index dir and repository
# use filecompare function to compare file in 3 different areas
# print status for each file

sub status{
    my ($filename) = @_;

    if ((! -e $filename) && &filecompare($filename, 4) == 0){
        print "$filename - file deleted\n";
    }
    elsif ((! -e $filename) && (! -e "$indexdir/$filename")){
        print "$filename - deleted\n";
    }
    elsif (&filecompare($filename, 3) == 0 && &filecompare($filename, 4) == 0){
        print "$filename - same as repo\n";
    }
    elsif (&filecompare($filename, 2) == 0 && &filecompare($filename, 3) == 2){
        print "$filename - added to index\n";
    }
    elsif (( -e $filename) && &filecompare($filename, 2) == 2){
        print "$filename - untracked\n";
    }
    elsif (&filecompare($filename, 2) == 1 && &filecompare($filename, 4) == 1){
        print "$filename - file changed, different changes staged for commit\n";
    }
    elsif (&filecompare($filename, 2) == 0 && &filecompare($filename, 4) == 1){
        print "$filename - file changed, changes staged for commit\n";
    }
    elsif (&filecompare($filename, 2) == 1 && &filecompare($filename, 4) == 0){
        print "$filename - file changed, changes not staged for commit\n";
    }
}


# Function 8: branch 
# have 3 options to display all branches, add or delete branches
# UPDATE: invalid branch name detection enforced

sub branch{
    (my $branchname, my $option) = @_;
    my @subdir = &opensub();

    # invalid branch name:
    # 1. contains illegal characters (apart from alphanumeric, dot, dash, and underline symbols)
    # 2. starts with non-alphanumeric symbol
    # 3. entirely numeric (no alphabetic symbols)

    if ($branchname =~ /[^_a-zA-Z0-9\.\-]/ or $branchname =~ /^[^a-zA-Z0-9]/ or $branchname !~ /[a-zA-Z]/){
        print "legit.pl: error: invalid branch name '$branchname'\n";
        exit 1;
    }

    # option 1: print all the branches in legit 
    if ($option == 1){
        my %branches = ();
        $branches{master} = 1;

        foreach my $file (glob "$legitdir/*"){
            if (basename($file) =~ /branch\.(.*)/){
                $branches{$1} = 1;
            }
        }
        
        foreach my $b (sort keys %branches){
            print "$b\n";
        }
    }
    # option 2: delete a branch with error checking
    elsif ($option == 2){
        if ($branchname eq 'master'){
            print "legit.pl: error: can not delete branch '$branchname'\n";
            exit 1;
        }
        elsif (! -e "$legitdir/branch.$branchname"){
            print "legit.pl: error: branch '$branchname' does not exist\n";
            exit 1;
        }
        else{
            # check if this branch has been merged
            my $branchcommit = (reverse sort &readspcbranch($branchname))[0];
            my $mastercommit = (reverse sort &readbranch(3))[0];
            my $mergecmp = 0; 

            foreach my $file (glob "$legitdir/.commit.$branchcommit/*"){
                my $bsfile = basename($file);

                if (! -e "$legitdir/.commit.$mastercommit/$bsfile"){
                    $mergecmp = 1;
                }
                else{
                    $mergecmp = 1 if (compare("$file", "$legitdir/.commit.$mastercommit/$bsfile") == 1);
                }
                
            }
            if ($mergecmp == 1){
                print "legit.pl: error: branch '$branchname' has unmerged changes\n";
                exit 1;
            }
            else{
                unlink("$legitdir/branch.$branchname");
                print "Deleted branch '$branchname'\n";
            }
        }
    }
    # option 3: create a branch with error checking
    elsif ($option == 3){
        if (( -e "$legitdir/branch.$branchname") or ($branchname eq 'master')){
            print "legit.pl: error: branch '$branchname' already exists\n";
            exit 1;
        }
        else{
            my @branchcommit = &readbranch(2);
            open F, '>', "$legitdir/branch.$branchname";
            foreach my $commitnum (@branchcommit){
                print F "COMMIT:$commitnum\n";
            }
            close F;
        }
    }
}


# Function 9: checkout
# Switch to a branch with error-checking
# UPDATE: over-written detection enforced
# UPDATE: over-written detection enforced

sub checkout{
    my ($branchname) = @_;

    if (! -e "$legitdir/branch.$branchname"){
        print "legit.pl: error: unknown branch '$branchname'\n";
        exit 1;
    }

    if ($branchname eq &readbranch(1)){
        print "Already on '$branchname'\n";
        exit 0;
    }

    # this is the latest commit number of the current branch
    my $curbranchcommit = (reverse sort &readbranch(2))[0];
    my $newbranchcommit = (reverse sort &readspcbranch($branchname))[0];

    # overwritten checking
    # if the file in working directory satisfies:
    # 1. file modified, and has not been committed to current branch
    # 2. file exists in the branch which users want to checkout
    # 3. file has been overwritten (check line by line between working dir and the branch-to-checkout)

    my @overwritten = ();
    foreach my $wkfile (glob "*"){
        my $curcommitdir = "$legitdir/.commit.$curbranchcommit";
        my $newcommitdir = "$legitdir/.commit.$newbranchcommit";

        if ((! -e "$curcommitdir/$wkfile") or compare("$wkfile", "$curcommitdir/$wkfile") == 1){
            if (( -e "$newcommitdir/$wkfile")){
                open N, '<', "$newcommitdir/$wkfile" or die "cannot open $newcommitdir/$wkfile\n";
                my @newcontent = <N>;
                close N;

                open W, '<', "$wkfile" or die "cannot open $wkfile\n";
                my @wkcontent = <W>;
                close W;

                my $linenum = 0;
                while ($linenum < @newcontent){
                    if ($linenum >= @wkcontent or $newcontent[$linenum] ne $wkcontent[$linenum]){
                        push @overwritten, $wkfile;
                        last;
                    }
                    $linenum += 1;
                }
            } 
        }
    }
    if (@overwritten > 0){
        print "legit.pl: error: Your changes to the following files would be overwritten by checkout:\n";
        foreach my $file (sort @overwritten){
            print "$file\n";
        }
        exit 1;
    }

    # checkout implementation
    # stage 1: update the mastery file

    open F, '>', "$legitdir/.BRANCHINFO";
    print F "MASTERY:$branchname";
    close F;

    # stage 2: update files in working directory according to the branch's last commit
    foreach my $curfile (glob "$legitdir/.commit.$curbranchcommit/*"){
        my $bscurfile = basename($curfile);
        my $samenewfile = "$legitdir/.commit.$newbranchcommit/$bscurfile";

        # if the file in working dir is not in new branch's last commit, delete it
        if (! -e "$samenewfile"){
            unlink("$bscurfile");
        }

        # if the file in working dir exists in current branch's last commit and new branch's last commit
        # and the file is different to new branch's last commit, update it according to new branch's last commit

        elsif ( -e "$samenewfile" && compare("$bscurfile", "$curfile") == 0 && compare("$bscurfile", "$samenewfile") == 1){
            copy("$samenewfile", "$bscurfile") or die "Copying $bscurfile failed!\n";
        }
    }

    my @torefresh = ();

    # stage 3: cleanse the index directory if has been committed to refresh

    foreach my $indexfile (glob "$indexdir/*"){
        my $bsindexfile = basename($indexfile);
        my $commitfile = "$legitdir/.commit.$curbranchcommit/$bsindexfile";

        if ( -e "$commitfile" && compare ("$indexfile", "$commitfile") == 0){
            push @torefresh, $bsindexfile;
            unlink ("$indexfile");
        }
    }

    # stage 4: if file not in working directory, copy to it
    # if file not in index directory, copy to it

    foreach my $newfile (glob "$legitdir/.commit.$newbranchcommit/*"){
        my $bsnewfile = basename($newfile);
        if (! -e "$bsnewfile"){
            copy("$newfile", "$bsnewfile") or die "Copying $bsnewfile failed!\n";
        }
        if (! -e "$indexdir/$bsnewfile"){
            copy("$newfile", "$indexdir/$bsnewfile") or die "Copying $bsnewfile failed!\n";
        }

        # stage 5: refresh the index directory
        foreach my $trfile (@torefresh){
            if ($trfile eq $bsnewfile){
                copy("$newfile", "$indexdir/$bsnewfile") or die "Copying $bsnewfile failed!\n";
                last;
            }
        }
    }
    print "Switched to branch '$branchname'\n";
}


# Function 10: merge
# Switch to a branch with error-checking
# UPDATE: can merge with commit number
# UPDATE: conflicts detection enforced

sub merge{
    (my $tomerge, my $message) = @_;
    my $lastbranch = '';    # the last commit of branch-to-merge
    my $firstbranch = '';   # the first commit of this branch, the commit that master and branch separated

    # option 1: merge with branch name
    if ($tomerge =~ /[a-zA-Z]/){
        if (! -e "$legitdir/branch.$tomerge"){
            print "legit.pl: error: unknown branch '$tomerge'\n";
            exit 1;
        }
        else{
            my $lastbranchcommit = (reverse sort &readspcbranch($tomerge))[0];
            my $firstbranchcommit = (sort &readspcbranch($tomerge))[0];

            $lastbranch = "$legitdir/.commit.$lastbranchcommit";
            $firstbranch = "$legitdir/.commit.$firstbranchcommit";
        }
    }
    # option 2: merge with commit number
    else{
        if (! -d "$legitdir/.commit.$tomerge"){
            print "legit.pl: error: unknown commit '$tomerge'\n";
            exit 1;
        }
        else {
            $lastbranch = "$legitdir/.commit.$tomerge";

            # find the first commit of this branch, when merge with commit number
            # 1. find which branch creates this commit
            # 2. extract the first commit of the branch

            foreach my $branch (glob "$legitdir/*"){
                my $bsbranch = basename($branch);
                if ($bsbranch =~ /branch\.(.*)/ ){
                    my $branchname = $1;
                    my $lastcommit = (reverse sort &readspcbranch($branchname))[0];
                    if ($lastcommit == $tomerge){
                        my $firstbranchcommit = (sort &readspcbranch($branchname))[0];
                        $firstbranch = "$legitdir/.commit.$firstbranchcommit";
                        $tomerge = $branchname;
                        last;
                    }
                }
            }
        }
    }

    # defining : define the last commit of current branch as last master (NOT mean master branch)

    my $lastmastercommit = (reverse sort &readbranch(3))[0];    # the last commit of current branch
    my $lastmaster = "$legitdir/.commit.$lastmastercommit";    # the last commit dir of current branch
    my $lastmastername = &readbranch(1);     # the branch name which users currently in

    # situation 1: if try to merge branch which are currently in, 
    # or the branch has not further committed, that's already updated

    if ($lastmaster eq $lastbranch or $tomerge eq &readbranch(1)){
        print "Already up to date\n";
        exit 0;
    }

    # situation 2: if current branch pointer same as firstbranch
    # means current branch has not been changed after this branch created, fast-forward will be in use
    # update the current branch pointer to the branch's last commit, and the mastery pointer to current branch

    if ($lastmaster eq $firstbranch){
        
        open M, '>', "$legitdir/.BRANCHINFO";
        print M "MASTERY:$lastmastername";
        close M;

        # as master has not been modified, just update files according to last branch commit
        foreach my $lbfile (glob "$lastbranch/*"){
            my $bslbfile = basename($lbfile);
            copy("$lbfile", "$bslbfile") or die "fast-forward : copying $bslbfile failed!\n";
            copy("$lbfile", "$indexdir/$bslbfile") or die "fast-forward : copying $bslbfile failed!\n";
        }

        foreach my $wkfile (glob "*"){
            my $bswkfile = basename($wkfile);
            if (! -e "$lastbranch/$bswkfile" && -e "$lastmaster/$bswkfile"){
                unlink("$wkfile"); 
            }
        }

        foreach my $indexfile (glob "$indexdir/*"){
            my $bsindexfile = basename($indexfile);
            if (! -e "$lastbranch/$bsindexfile" && -e "$lastmaster/$bsindexfile"){
                unlink("$indexfile");
            }
        }

        &logupdate($tomerge, $lastmastername);
        print "Fast-forward: no commit created\n";
        exit 0;
    }
    
    # situation 3: master pointer not same as firstbranch
    # means master has been changed after this branch created
    # check if conflicts exist, then auto-merging will be in use

    my @conflicts = ();

    foreach my $branchfile (glob "$lastbranch/*"){
        my $bsbranchfile = basename($branchfile);
        if (-e "$lastmaster/$bsbranchfile" && -e "$firstbranch/$bsbranchfile"){
            open L, '<', "$branchfile";
            my @lb = <L>;
            close L;

            open M, '<', "$lastmaster/$bsbranchfile";
            my @lm = <M>;
            close M;

            open F, '<', "$firstbranch/$bsbranchfile";
            my @fb = <F>;
            close F;

            my $i = 0;
            while ($i < @lb && $i < @lm){

                # conflicts 1: file in first branch is shorter than file in last branch and last master
                # and further line content is different between file in last branch and last master

                if ($i >= @fb){
                    if ($lm[$i] ne $lb[$i]){
                        push @conflicts, $bsbranchfile;
                        last;
                    }
                }

                # conflicts 2: a line in file is different between first branch, last branch and last master

                elsif ($fb[$i] ne $lm[$i] && $fb[$i] ne $lb[$i] && $lm[$i] ne $lb[$i]){
                    push @conflicts, $bsbranchfile;
                    last;
                }
                $i += 1;
            }
        }

        # conflicts 3: file not in first branch, and file is different between last branch and last master
        
        elsif ((-e "$lastmaster/$bsbranchfile") && (! -e "$firstbranch/$bsbranchfile")){
            push @conflicts, $bsbranchfile if (compare("branchfile", "$lastmaster/$bsbranchfile") == 1);
        }
    }
    if (@conflicts > 0){
        print "legit.pl: error: These files can not be merged:\n";
        foreach my $file (sort @conflicts){
            print "$file\n";
        }
        exit 1;
    }
    else{
        &mergeimp($firstbranch, $lastbranch, $lastmaster);
        &commit($message);
        &logupdate($tomerge, $lastmastername);
    }
}


# Sub-function 5: auto-merging implementation (4 stages)
# USED BY MERGE

sub mergeimp{
    (my $firstbranch, my $lastbranch, my $lastmaster) = @_;

    # stage 1. if file in last branch commit not in last master commit, copy it to working dir then add
    # stage 2. if file in both last branch commit and last master commit, merge it then add

    foreach my $branchfile (glob "$lastbranch/*"){
        my $bsbranchfile = basename($branchfile);
        if (! -e "$lastmaster/$bsbranchfile"){
            copy("$branchfile","$bsbranchfile") or die "merge : copying $bsbranchfile failed!\n";
        }
        else{
            open L, '<', "$branchfile";
            my @lb = <L>;
            close L;

            open M, '<', "$lastmaster/$bsbranchfile";
            my @lm = <M>;
            close M;

            my $i = 0;
            my @merged = ();

            if ( -e "$firstbranch/$bsbranchfile"){
                open F, '<', "$firstbranch/$bsbranchfile";
                my @fb = <F>;
                close F;

                # merge after error checking, if file length :
                # 1. first branch < last master <= last branch : based on last branch
                # 2. first branch < last branch < last master : based on last master
                # 3. in same length, based on the updated content

                while ($i < @lb or $i < @lm){
                    if ($i >= @fb && $i < @lb){
                        push @merged, $lb[$i];
                    }
                    elsif ($i >= @fb && $i >= @lb && $i < @lm){
                        push @merged, $lm[$i];
                    }
                    elsif ($i < @fb && $i < @lb && $i < @lm){
                        if ($fb[$i] eq $lb[$i] && $lb[$i] ne $lm[$i]){
                            push @merged, $lm[$i];
                        }
                        else{
                            push @merged, $lb[$i];
                        }
                    }
                    $i += 1;
                }
            }

            # if file does not exist in first branch, merged is lastmaster
            # after error checking, last master is same as last branch

            else{
                @merged = @lm;
            }

            open F, '>', "$bsbranchfile";
            foreach my $line (@merged){
                print F "$line";
            }
            close F;
            print "Auto-merging $bsbranchfile\n";
        }
        &add($bsbranchfile);
    }

    # stage 3. if file not in branch last commit but in branch first commit
    # this means file has been deleted in this branch, should also delete it in new commit

    foreach my $fbfile (glob "$firstbranch/*"){
        my $bsfbfile = basename($fbfile);
        if (! -e "$lastbranch/$bsfbfile"){
            unlink ("$bsfbfile");
            unlink ("$indexdir/$bsfbfile") if ( -e "$indexdir/$bsfbfile");
            &add($bsfbfile);
        }
    }

    # stage 4. if file not in branch last commit also not in branch first commit, but in last master commit
    # this means file has been created in master after create a branch, should be added to new commit

    foreach my $lmfile (glob "$lastmaster/*"){
        my $bslmfile = basename($lmfile);
        if (! -e "$lastbranch/$bslmfile" && ! -e "$firstbranch/$bslmfile"){
            copy("$lmfile", "$bslmfile");
            &add($bslmfile);
        }
    }
}


# Sub-function 7: log update
# update the log, all commits belong to branch will also belong to lastmaster
# USED BY MERGE

sub logupdate{
    (my $tomerge, my $lastmastername) = @_;

    my @allcommits = &readspcbranch($tomerge);
    my @lastmastercommits = &readbranch(2);

    foreach my $bcommit (@allcommits){
        my $commitfound = 0;
        foreach my $mcommit (@lastmastercommits){
            if ($bcommit == $mcommit){
                $commitfound = 1;
                last;
            }
        }
        if ($commitfound == 0){
            open F, '>>', "$legitdir/branch.$lastmastername";
            print F "COMMIT:$bcommit\n";
            close F;
        }
    }
}


# Sub-Function 8: legit commands manual
# print the legit commands specification
# USED BY MAIN SWITCH

sub manual{
    print "Usage: legit.pl <command> [<args>]\n\n";
    print "These are the legit commands:\n";
    print "   init       Create an empty legit repository\n";
    print "   add        Add file contents to the index\n";
    print "   commit     Record changes to the repository\n";
    print "   log        Show commit log\n";
    print "   show       Show file at particular state\n";
    print "   rm         Remove files from the current directory and from the index\n";
    print "   status     Show the status of files in the current directory, index, and repository\n";
    print "   branch     list, create or delete a branch\n";
    print "   checkout   Switch branches or restore current directory files\n";
    print "   merge      Join two development histories together\n\n";
    exit 1;
} 


# Main switch

if (@ARGV == 0){
    &manual();
}
elsif ($ARGV[0] eq 'init'){
    if (@ARGV != 1){
        print "usage: legit.pl init\n";
        exit 1;
    }
    &init();
}
elsif ($ARGV[0] eq 'add' && @ARGV >= 2){
    &legitcheck(1);
    shift(@ARGV);
    foreach my $file (@ARGV){
        if ($file =~ /^\-/){
            print "usage: legit.pl add <filenames>\n";
            exit 1;
        }
    }
    &add(@ARGV);
}
elsif ($ARGV[0] eq 'commit'){
    &legitcheck(1);
    if (@ARGV == 3 && $ARGV[1] eq '-m' && $ARGV[2] !~ /^\-/){
        &commit($ARGV[2]);
    }
    elsif (@ARGV == 4 && $ARGV[1] eq '-a' && $ARGV[2] eq '-m' && $ARGV[3] !~ /^\-/){
        my @filearr = ();
        foreach my $file (glob "$indexdir/*"){
            push @filearr, basename("$file");
        }
        &add(@filearr);
        &commit($ARGV[3]);
    }
    else{
        print "usage: legit.pl commit [-a] -m commit-message\n";
        exit 1;
    }
}
elsif ($ARGV[0] eq 'log'){
    &legitcheck(2);
    if (@ARGV != 1){
        print "usage: legit.pl log\n";
        exit 1;
    }
    &log();
}
elsif ($ARGV[0] eq 'show'){
    &legitcheck(2);
    if (@ARGV != 2 or $ARGV[1] =~ /^\-/){
        print "usage: legit.pl show <commit>:<filename>\n";
        exit 1;
    }
    if ($ARGV[1] =~ /(\d+):(.*)/){
        &show($1, $2);
    }
    elsif ($ARGV[1] =~ /^:(.*)/){
        &show(-1, $1);
    }
    else{
        print "legit.pl: error: invalid object $ARGV[1]\n";
        exit 1;
    }
}
elsif ($ARGV[0] eq 'rm' && @ARGV >= 2){
    &legitcheck(2);
    shift(@ARGV);
    my $force = 0;
    my $cached = 0;
    my @rmfile = ();

    while (@ARGV > 0){
        my $symbol = shift(@ARGV);
        if ($symbol eq '--force'){
            $force = 1;
        }
        elsif ($symbol eq '--cached'){
            $cached = 1;
        }
        else{
            push @rmfile, $symbol;
        }
    }
    
    if ($force == 1 && $cached == 1){
        foreach my $file (@rmfile){
            &rmcheck($file, 'fc');
        }
        foreach my $file (@rmfile){
            &rm($file, 'fc');
        }
    }
    elsif ($force == 1 && $cached == 0){
        foreach my $file (@rmfile){
            &rmcheck($file, 'f');
        }
        foreach my $file (@rmfile){
            &rm($file, 'f');
        }
    }
    elsif ($force == 0 && $cached == 1){
        foreach my $file (@rmfile){
            &rmcheck($file, 'c');
        }
        foreach my $file (@rmfile){
            &rm($file, 'c');
        }
    }
    else{
        foreach my $file (@rmfile){
            &rmcheck($file, 'n');
        }        
        foreach my $file (@rmfile){
            &rm($file, 'n');
        }
    }
}
elsif ($ARGV[0] eq 'status'){
    &legitcheck(2);
    my %filearr = ();
    foreach my $file (glob "*"){
        $filearr{basename($file)} += 1;
    }
    foreach my $file (glob "$indexdir/*"){
        $filearr{basename($file)} += 1;
    }
    my $suffix = &commitseq(2);
    if ($suffix >= 0){
        foreach my $file (glob "$legitdir/.commit.$suffix/*"){
            $filearr{basename($file)} += 1;
        }
    }
    foreach my $filename (sort keys %filearr){
        &status($filename);
    }
}
elsif ($ARGV[0] eq 'branch'){
    &legitcheck(2);
    if (@ARGV == 1){
        &branch('all', 1);
    }
    else{
        shift(@ARGV);
        my $delete = 0;
        my @branchfile = ();

        while (@ARGV > 0){
            my $symbol = shift(@ARGV);
            if ($symbol eq '-d'){
                $delete = 1;
            }
            elsif ($symbol !~ /^\-/){
                push @branchfile, $symbol;
            }
            else{
                print "usage: legit.pl branch [-d] <branch>\n";
                exit 1;
            }
        }

        if (@branchfile == 0 && $delete == 1){
            print "legit.pl: error: branch name required\n";
            exit 1;
        }
        if (@branchfile > 1){
            print "usage: legit.pl branch [-d] <branch>\n";
            exit 1;
        }

        if ($delete == 0){
            &branch($branchfile[0], 3);
        }
        else{
            &branch($branchfile[0], 2);
        }
    }
}
elsif ($ARGV[0] eq 'checkout'){
    &legitcheck(2);
    if (@ARGV != 2 or $ARGV[1] !~ /^[a-zA-Z0-9]/){
        print "usage: legit.pl checkout <branch>\n";
        exit 1;
    }
    &checkout($ARGV[1]);
}
elsif ($ARGV[0] eq 'merge'){
    &legitcheck(2);
    if (@ARGV == 2 && $ARGV[1] !~ /^\-/){
        print "legit.pl: error: empty commit message\n";
        exit 1;
    }
    elsif (@ARGV == 4 && $ARGV[1] !~ /^\-/ && $ARGV[2] eq '-m' && $ARGV[3] !~ /^\-/){
        &merge($ARGV[1], $ARGV[3]);
    }
    elsif (@ARGV == 4 && $ARGV[1] eq '-m' && $ARGV[2] !~ /^\-/ && $ARGV[3] !~ /^\-/){
        &merge($ARGV[3], $ARGV[2]);
    }
    else {
        print "usage: legit.pl merge <branch|commit> -m message\n";
        exit 1;
    }
}
else{
    print "legit.pl: error: unknown command st\n";
    &manual();
}


# Written by Zhou JIANG, z5146092

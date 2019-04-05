#!/bin/sh

# MUST USE IFS setting to avoid blanks in filenames
# only using double quotes cannot avoid
IFS=$'\n'

for file in `find "$1" -type f`
do
    bsfile=`basename "$file"`
    if ([ -e ""$2"/"$bsfile"" ])
    then
        diff "$file" ""$2"/"$bsfile"" >/dev/null
        if test $? -eq 0
        then
            echo "$bsfile"
        fi
    fi
done

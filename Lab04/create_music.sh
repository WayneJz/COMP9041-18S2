#!/bin/sh -e 

if !(test $# -eq 2);
then
    echo 'Must 2 arguments be given'
    exit 1
fi

wget -q -O- 'https://en.wikipedia.org/wiki/Triple_J_Hottest_100?action=raw'|while read line
do
    if [[ "$line" =~ (Triple J Hottest 100, )+[0-9][0-9][0-9][0-9] ]]
    then
       year=`echo "$line"|sed "s/[^0-9]//g"|cut -c 8-`
       folder="$2/Triple J Hottest 100, $year"
       mkdir -p -m u+x "$folder"
    fi
    count=1
    while read line && test $count -le 10
    do
        if !([[ "$line" =~ ^\# ]]);
        then
            continue
        fi
        
        line=`echo "$line"|sed 's/[^[]*|//g'|sed 's/\//-/g'|tr -d '[]"#'`
        artist=`echo "$line"|sed 's/\xe2\x80\x93.*//'|sed 's/^[ ]*//'|sed 's/[ ]*$//'`
        title=`echo "$line"|sed 's/.*\xe2\x80\x93//'|sed 's/^[ ]*//'|sed 's/[ ]*$//'`

        fake_file="$folder/$track - $title - $artist.mp3"
        cp -p "$1" "$fake_file"
        count=$((count + 1))
    done
done

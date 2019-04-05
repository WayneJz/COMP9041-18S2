#!/bin/sh

for folder in "$@"
do
    album=`echo "$folder"|cut -d "/" -f 2`
    year=`echo "$folder"|cut -d "/" -f 2|cut -d "," -f 2|sed "s/^[ ]*//g"`
    
    #delete tailing slash symbol
    fname_noslash=`echo "$folder"|sed "s/\/*$//g"`
    
    for file in "$fname_noslash"/*.mp3
    do
        track=`echo "$file"|cut -d "/" -f 3|cut -d " " -f 1`
    
        other=`echo "$file"|cut -d "/" -f 3|sed "s/[ ]-[ ]/\//g"` 
        title=`echo "$other"|cut -d "/" -f 2`
    
        #extract and eliminate tail suffices
        artist=`echo "$other"|cut -d "/" -f 3|sed "s/\.mp3$//g"`    
        #modify id3 tags and silent output to dev/null
        id3 "$file" -t "$title" -T "$track" -a "$artist" -A "$album" -y "$year" >/dev/null    
    done
done



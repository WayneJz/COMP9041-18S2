#!/bin/sh

for file in *.htm
do
    cname=`echo "$file"|sed "s/\..*//g"`
    htmlname="$cname.html"
    if [ -f "$htmlname" ];
    then
        echo "$htmlname exists"
        exit 1
    fi

    # this avoids if no .htm files, mv command prompts error
    if [ -f "$file" ];
    then
       mv "$file" "$htmlname"
    fi
done

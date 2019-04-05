#!/bin/sh -e

if !(test $# -eq 1);
then
    echo 'Must 1 argument be given'
    exit 1
fi

if !([ -f "$1" ]);
then
    echo 'Requested file does not exists'
    exit 1
fi

date_info=`ls -l "$1"|cut -d " " -f 6-8`

convert -gravity south -pointsize 36 -draw "text 0,10 '$date_info'" "$1" temporary_file.jpg

mv temporary_file.jpg "$1"

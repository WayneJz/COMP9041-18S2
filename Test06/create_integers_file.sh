#!/bin/sh -e

i=$1

while test $i -le $2
do 
    echo "$i" >> "$3"
    let i+=1
done

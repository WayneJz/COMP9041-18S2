#!/bin/sh

for file in $@
do
    includes=`cat "$file"|egrep "(#include)[[:space:]]*\""|cut -d "\"" -f 2`
    for head in `echo "$includes"`
    do
        if !([ -f "$head" ])
        then
           echo "$head included into $file does not exist"
        fi
    done
done

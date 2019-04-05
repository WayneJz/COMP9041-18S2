#!/bin/sh -e

suffix=0

while [[ -f ".${1}.${suffix}" ]] 
do
    suffix=$((suffix+1))
done

cp "$1" ".${1}.${suffix}"
echo "Backup of '$1' saved as '.${1}.${suffix}'"

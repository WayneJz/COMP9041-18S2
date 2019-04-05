#!/bin/sh

cat "$1"|egrep "COMP[29]041"|cut -d "|" -f 3|cut -d "," -f 2|cut -d " " -f 2|sort -n|uniq -c|sort -n -r|head -n 1|cut -c 9-

#!/bin/sh -e


cat "$1"|egrep "[A-Z]+"|cut -d ":" -f 2|cut -d "," -f 1|sed "s/^ //g"|sed "s/\"//g"|sort -n|uniq|sort -n

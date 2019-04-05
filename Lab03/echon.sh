#!/bin/sh

if !(test $# -eq 2);
then
   echo 'Usage: ./echon.sh <number of lines> <string>'
   exit -1;
fi

if (echo $1) | egrep -q '[^[:digit:]]+';
then
   echo './echon.sh: argument 1 must be a non-negative integer'
   exit -1;
elif test $1 -lt 0;
then
   echo './echon.sh: argument 1 must be a non-negative integer'
   exit -1;
fi

for ((i=1;i<=$1;i++));
do
   echo $2;
done

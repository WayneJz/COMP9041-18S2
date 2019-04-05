#!/bin/sh

if !( test $# -eq 1 );
then
    echo 'Usage: ./shuffle_test <file to randomly display>'
    exit 1
fi

if !([ -r "$1" ]) || !([ -r "shuffle.pl" ]);
then
    echo "Cannot open file "$1" or shuffle.pl does not exist!"
    exit 1
fi


echo "The shuffle.pl displays such result:"
perl shuffle.pl < "$1"

echo "The original file "$1" displays:"
cat "$1"

perl shuffle.pl < "$1" |sort -n > shuffle_test1.txt

diff shuffle_test1.txt "$1" >/dev/null

if test $? -eq 0;
then
   echo 'Test 1 SUCCESS: Result contains all original numbers.'
else
   echo 'Test 1 FAILED: Result does not contain all original numbers!'
fi

perl shuffle.pl < "$1"  > shuffle_test2.txt

diff shuffle_test2.txt "$1" >/dev/null

if test $? -eq 1;
then
   echo 'Test 2 SUCCESS: Numbers are randomly displayed.'
else
   echo 'Test 2 FAILED: Numbers are in same sequence as original one!'
   echo 'NOTE: Random sequence can be same as original sequence, please try again!'
fi


#!/bin/sh

# Created by Zhou JIANG, z5146092

if !([ -r "legit.pl" ]);
then
    echo "Cannot open file legit.pl - file does not exist!"
    exit 1
fi

if ([ -d ".legit" ]);
then
    rm -rf ".legit/"
fi

echo -e "\e[31m=====================================================\e[0m"
echo -e "\e[31mTEST00 (test for edge input, illegal input and some errors)\e[0m"

echo -e "\e[33mperl legit.pl init\e[0m" 
perl legit.pl init
echo -e "\e[33mecho 10 >a\e[0m"
echo 10 >a
echo -e "\e[33mperl legit.pl add -a\e[0m"
perl legit.pl add -a
echo -e "\e[33mperl legit.pl add *\e[0m"
perl legit.pl add *
echo -e "\e[33mperl legit.pl show a\e[0m"
perl legit.pl show a
echo -e "\e[33mperl legit.pl commit -m %*#e12(-\e[0m"
perl legit.pl commit -m %*#
echo -e "\e[33mperl legit.pl show :a\e[0m"
perl legit.pl show :a
echo -e "\e[33mperl legit.pl branch 000123123\e[0m"
perl legit.pl branch 000123123
echo -e "\e[33mperl legit.pl branch abc-723_er\e[0m"
perl legit.pl branch abc-723_er
echo -e "\e[33mperl legit.pl checkout abc-723_er\e[0m"
perl legit.pl checkout abc-723_er
echo -e "\e[33mperl legit.pl checkout abc-723_er\e[0m"
perl legit.pl checkout abc-723_er
echo -e "\e[33mecho 5 >b\e[0m"
echo 5 >b
echo -e "\e[33mperl legit.pl add b\e[0m"
perl legit.pl add b
echo -e "\e[33mperl legit.pl commit -m abc\e[0m"
perl legit.pl commit -m abc
echo -e "\e[33mperl legit.pl checkout master\e[0m"
perl legit.pl checkout master
echo -e "\e[33mperl legit.pl branch -d abc-723_er\e[0m"
perl legit.pl branch -d abc-723_er
echo -e "\e[33mperl legit.pl checkout abc-723_er\e[0m"
perl legit.pl checkout abc-723_er
echo -e "\e[33mperl legit.pl merge -m merged abc-723_er\e[0m"
perl legit.pl merge -m merged abc-723_er
echo -e "\e[33mperl legit.pl checkout master\e[0m"
perl legit.pl checkout master
echo -e "\e[33mperl legit.pl merge -m merged abc-723_er\e[0m"
perl legit.pl merge -m merged abc-723_er

echo -e "\e[31m=====================================================\e[0m"
echo -e "\e[31mTEST00 (test for edge input, illegal input and some errors) finished - cleansed created files: a b\e[0m"

rm -f a b

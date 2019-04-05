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
echo -e "\e[31mTEST09 (checkout after merge)\e[0m"

echo -e "\e[33mperl legit.pl init\e[0m" 
perl legit.pl init
echo -e "\e[33mecho hello >a\e[0m"
echo hello >a
echo -e "\e[33mperl legit.pl add a\e[0m"
perl legit.pl add a
echo -e "\e[33mperl legit.pl commit -m first\e[0m"
perl legit.pl commit -m first
echo -e "\e[33mperl legit.pl branch b1\e[0m"
perl legit.pl branch b1
echo -e "\e[33mperl legit.pl checkout b1\e[0m"
perl legit.pl checkout b1
echo -e "\e[33mecho world >a\e[0m"
echo world >>a
echo -e "\e[33mperl legit.pl commit -a -m second\e[0m"
perl legit.pl commit -a -m second
echo -e "\e[33mperl legit.pl branch b2\e[0m"
perl legit.pl branch b2
echo -e "\e[33mperl legit.pl checkout b2\e[0m"
perl legit.pl checkout b2
echo -e "\e[33mperl legit.pl merge -m merged1 b1\e[0m"
perl legit.pl merge -m merged1 b1
echo -e "\e[33mperl legit.pl status\e[0m"
perl legit.pl status
echo -e "\e[33mperl legit.pl checkout master\e[0m"
perl legit.pl checkout master
echo -e "\e[33mperl legit.pl status\e[0m"
perl legit.pl status
echo -e "\e[33mecho 9041 >b\e[0m"
echo 9041 >b
echo -e "\e[33mperl legit.pl add b\e[0m"
perl legit.pl add b
echo -e "\e[33mperl legit.pl commit -a -m third\e[0m"
perl legit.pl commit -a -m third
echo -e "\e[33mperl legit.pl merge -m merged2 b2\e[0m"
perl legit.pl merge -m merged2 b2
echo -e "\e[33mperl legit.pl log\e[0m"
perl legit.pl log
echo -e "\e[33mperl legit.pl status\e[0m"
perl legit.pl status

echo -e "\e[31m=====================================================\e[0m"
echo -e "\e[31mTEST09 (checkout after merge) finished - cleansed created files: a b\e[0m"

rm -f a b
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
echo -e "\e[31mTEST02 (status with branches)\e[0m"

echo -e "\e[33mperl legit.pl init\e[0m" 
perl legit.pl init
echo -e "\e[33mecho hi >a\e[0m"
echo hi >a
echo -e "\e[33mperl legit.pl add a\e[0m"
perl legit.pl add a
echo -e "\e[33mperl legit.pl status\e[0m"
perl legit.pl status
echo -e "\e[33mperl legit.pl commit -m first\e[0m"
perl legit.pl commit -m first
echo -e "\e[33mperl legit.pl branch b1\e[0m"
perl legit.pl branch b1
echo -e "\e[33mperl legit.pl rm a\e[0m"
perl legit.pl rm a
echo -e "\e[33mperl legit.pl checkout b1\e[0m"
perl legit.pl checkout b1
echo -e "\e[33mperl legit.pl status\e[0m"
perl legit.pl status
echo -e "\e[33mcat a\e[0m"
cat a
echo -e "\e[33mecho 9041 >>a\e[0m"
echo 9041 >>a
echo -e "\e[33mperl legit.pl add a\e[0m"
perl legit.pl add a
echo -e "\e[33mperl legit.pl status\e[0m"
perl legit.pl status
echo -e "\e[33mperl legit.pl commit -m second\e[0m"
perl legit.pl commit -m second
echo -e "\e[33mperl legit.pl status\e[0m"
perl legit.pl status
echo -e "\e[33mcat a\e[0m"
cat a
echo -e "\e[33mperl legit.pl checkout master\e[0m"
perl legit.pl checkout master
echo -e "\e[33mperl legit.pl status\e[0m"
perl legit.pl status
echo -e "\e[33mcat a\e[0m"
cat a
echo -e "\e[33mperl legit.pl merge -m merged b1\e[0m"
perl legit.pl merge -m merged b1
echo -e "\e[33mperl legit.pl status\e[0m"
perl legit.pl status
echo -e "\e[33mperl legit.pl rm a\e[0m"
perl legit.pl rm a
echo -e "\e[33mperl legit.pl add a\e[0m"
perl legit.pl add a
echo -e "\e[33mperl legit.pl status\e[0m"
perl legit.pl status
echo -e "\e[33mperl legit.pl commit -m third\e[0m"
perl legit.pl commit -m third
echo -e "\e[33mperl legit.pl status\e[0m"
perl legit.pl status


echo -e "\e[31m=====================================================\e[0m"
echo -e "\e[31mTEST02 (status with branches) finished - cleansed created files: a\e[0m"

rm -f a

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
echo -e "\e[31mTEST01 (rm in branch then merge)\e[0m"

echo -e "\e[33mperl legit.pl init\e[0m" 
perl legit.pl init
echo -e "\e[33mecho 10 >a\e[0m"
echo 10 >a
echo -e "\e[33mperl legit.pl add a\e[0m"
perl legit.pl add a
echo -e "\e[33mperl legit.pl commit -m first\e[0m"
perl legit.pl commit -m first
echo -e "\e[33mperl legit.pl branch b1\e[0m"
perl legit.pl branch b1
echo -e "\e[33mperl legit.pl checkout b1\e[0m"
perl legit.pl checkout b1
echo -e "\e[33mperl legit.pl show :a\e[0m"
perl legit.pl show :a
echo -e "\e[33mperl legit.pl show 0:a\e[0m"
perl legit.pl show 0:a
echo -e "\e[33mperl legit.pl rm a\e[0m"
perl legit.pl rm a
echo -e "\e[33mecho hello >b\e[0m"
echo hello >b
echo -e "\e[33mperl legit.pl add a b\e[0m"
perl legit.pl add a b
echo -e "\e[33mperl legit.pl commit -m second\e[0m"
perl legit.pl commit -m second
echo -e "\e[33mperl legit.pl checkout master\e[0m"
perl legit.pl checkout master
echo -e "\e[33mperl legit.pl merge -m merged b1\e[0m"
perl legit.pl merge -m merged b1
echo -e "\e[33mperl legit.pl show 1:b\e[0m"
perl legit.pl show 1:b
echo -e "\e[33mperl legit.pl show :a\e[0m"
perl legit.pl show :a
echo -e "\e[33mperl legit.pl show 1:a\e[0m"
perl legit.pl show 1:a

echo -e "\e[31m=====================================================\e[0m"
echo -e "\e[31mTEST01 (rm in branch then merge) finished - cleansed created files: a b\e[0m"

rm -f a b
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
echo -e "\e[31mTEST04 (log and show with multiple branches)\e[0m"

echo -e "\e[33mperl legit.pl init\e[0m" 
perl legit.pl init
echo -e "\e[33mecho hello >a\e[0m"
echo hello >a
echo -e "\e[33mperl legit.pl add a\e[0m"
perl legit.pl add a
echo -e "\e[33mperl legit.pl show :a\e[0m"
perl legit.pl show :a
echo -e "\e[33mperl legit.pl commit -m first\e[0m"
perl legit.pl commit -m first
echo -e "\e[33mperl legit.pl show :a\e[0m"
perl legit.pl show :a
echo -e "\e[33mperl legit.pl branch b1\e[0m"
perl legit.pl branch b1
echo -e "\e[33mperl legit.pl rm a\e[0m"
perl legit.pl rm a
echo -e "\e[33mperl legit.pl add a\e[0m"
perl legit.pl add a
echo -e "\e[33mperl legit.pl commit -m second\e[0m"
perl legit.pl commit -m second
echo -e "\e[33mperl legit.pl show 1:a\e[0m"
perl legit.pl show 1:a
echo -e "\e[33mperl legit.pl checkout b1\e[0m"
perl legit.pl checkout b1
echo -e "\e[33mperl legit.pl show :a\e[0m"
perl legit.pl show :a
echo -e "\e[33mperl legit.pl log\e[0m"
perl legit.pl log
echo -e "\e[33mperl legit.pl branch b2\e[0m"
perl legit.pl branch b2
echo -e "\e[33mecho world >>a\e[0m"
echo world >>a
echo -e "\e[33mperl legit.pl add a\e[0m"
perl legit.pl add a
echo -e "\e[33mperl legit.pl show :a\e[0m"
perl legit.pl show :a
echo -e "\e[33mperl legit.pl commit -m third\e[0m"
perl legit.pl commit -m third
echo -e "\e[33mperl legit.pl checkout b2\e[0m"
perl legit.pl checkout b2
echo -e "\e[33mperl legit.pl show :a\e[0m"
perl legit.pl show :a
echo -e "\e[33mecho 9041 is great >a\e[0m"
echo 9041 is great >a
echo -e "\e[33mperl legit.pl add a\e[0m"
perl legit.pl add a
echo -e "\e[33mperl legit.pl show :a\e[0m"
perl legit.pl show :a
echo -e "\e[33mperl legit.pl commit -m forth\e[0m"
perl legit.pl commit -m forth
echo -e "\e[33mperl legit.pl show 3:a\e[0m"
perl legit.pl show 3:a
echo -e "\e[33mperl legit.pl merge -m merged b1\e[0m"
perl legit.pl merge -m merged b1
echo -e "\e[33mperl legit.pl checkout master\e[0m"
perl legit.pl checkout master
echo -e "\e[33mperl legit.pl show :a\e[0m"
perl legit.pl show :a
echo -e "\e[33mperl legit.pl log\e[0m"
perl legit.pl log
echo -e "\e[33mperl legit.pl merge -m merged b2\e[0m"
perl legit.pl merge -m merged b2
echo -e "\e[33mperl legit.pl show :a\e[0m"
perl legit.pl show :a
echo -e "\e[33mperl legit.pl log\e[0m"
perl legit.pl log

echo -e "\e[31m=====================================================\e[0m"
echo -e "\e[31mTEST04 (log and show with multiple branches) finished - cleansed created files: a\e[0m"

rm -f a
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
echo -e "\e[31mTEST03 (test for usage information)\e[0m"

echo -e "\e[33mperl legit.pl init\e[0m" 
perl legit.pl init
echo -e "\e[33mecho hello world >a\e[0m"
echo hello world >a
echo -e "\e[33mperl legit.pl add a\e[0m"
perl legit.pl add a
echo -e "\e[33mperl legit.pl commit -a -m -first\e[0m"
perl legit.pl commit -a -m -first
echo -e "\e[33mperl legit.pl commit -m -a first\e[0m"
perl legit.pl commit -m -a first
echo -e "\e[33mperl legit.pl commit -a -m first\e[0m"
perl legit.pl commit -a -m first
echo -e "\e[33mperl legit.pl show\e[0m"
perl legit.pl show
echo -e "\e[33mperl legit.pl log a\e[0m"
perl legit.pl log a
echo -e "\e[33mperl legit.pl rm --foo a\e[0m"
perl legit.pl rm --foo a
echo -e "\e[33mperl legit.pl rm --foo --cached a\e[0m"
perl legit.pl rm --foo --cached a
echo -e "\e[33mperl legit.pl branch -d -m\e[0m"
perl legit.pl branch -d -m
echo -e "\e[33mperl legit.pl checkout -a\e[0m"
perl legit.pl checkout -a
echo -e "\e[33mperl legit.pl merge -m\e[0m"
perl legit.pl merge -m
echo -e "\e[33mperl legit.pl merge -m message -n\e[0m"
perl legit.pl merge -m message -n
echo -e "\e[33mperl legit.pl invaild-command\e[0m"
perl legit.pl invaild-command

echo -e "\e[31m=====================================================\e[0m"
echo -e "\e[31mTEST03 (test for usage information) finished - cleansed created files: a\e[0m"

rm -f a


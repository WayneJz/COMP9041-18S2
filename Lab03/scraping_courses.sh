#!/bin/sh

if test $# != 1
then
   echo 'Must 1 word should be given'
   exit 1
fi

base_ug_url='http://www.handbook.unsw.edu.au/vbook2018/brCoursesByAtoZ.jsp?StudyLevel=Undergraduate&descr='
base_pg_url='http://www.handbook.unsw.edu.au/vbook2018/brCoursesByAtoZ.jsp?StudyLevel=Postgraduate&descr='

wget -q -O- "$base_ug_url$1" "$base_pg_url$1"|egrep "$1[[:digit:]]{4}.html"|
sed "s/.*\($1[0-9][0-9][0-9][0-9]\)\.html[^>]*> *\([^<]*\).*/\1 \2/"|
sed 's/ *$//'|
sort|
uniq

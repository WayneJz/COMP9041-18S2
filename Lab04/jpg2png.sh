#!/bin/sh

for file in *.jpg
do
   file_head=`echo "$file"|sed "s/\.jpg//"`;
   new_file="$file_head.png";

   # also test -e "$file_head\.png" is ok
   if [ -f "$new_file" ];
   then
      echo "$new_file already exists";
      continue;
   else
      convert "$file" "$new_file";
   fi
done

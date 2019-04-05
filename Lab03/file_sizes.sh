#!/bin/sh

sf='Small files:'
mf='Medium-sized files:'
lf='Large files:'

for file in *
do
  file_line=`wc -l <$file`
  if [[ $file_line -lt 10 ]];
  then
     sf="$sf $file"
  elif [[ $file_line -lt 100 ]];
  then   
     mf="$mf $file"
  else
     lf="$lf $file"
  fi
done

echo $sf
echo $mf
echo $lf

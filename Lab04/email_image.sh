#!/bin/sh -e

if test $# -eq 0;
then
  echo "$0: Image name(s) must be given";
  exit 1;
fi

for file in $@
do
  if !([ -f "$file" ]);
  then
    echo "$0: Image name $file does not exist!";
    exit 1;
  fi
done

echo 'Address to e-mail this image to?'
read "email"
if test -z "$email";
then
   echo "$0: Address must be given";
   exit 1;
fi


echo 'Message to accompany image?';
read "message";
if test -z "$message";
then
   echo "$0: Address must be given";
   exit 1;
fi

for image in $@
do
   #subject=`echo "$image"|sed "s/\..*//"`;
   echo "$message"|mutt -s "$message" -e 'set copy=no' -a "$file" -- "$email";
   echo "$file sent to $email";
done

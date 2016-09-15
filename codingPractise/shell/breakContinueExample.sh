#!/bin/bash


echo Control Flow introduction 
:<<'END'

while loop
  while test; do
    ;; code to be repeated
  done


until loop
  until test; do
    ;; code to be repeated
  done
repeats code in the block, continues as long as test returns false


the classsic for loop
for VAR in WORDS; do
  ;; code to be repeated
done

example:
for i in just a list of words; do echo $i; done

s="this variable contains a list of words"
for i in $s; do echo $i; done

The C-Style for loop
for(( INIT; TEST; UPDATE ));do
  ;; loop code
done

Break and continue
break
quits the loop
continue
skips the rest of the current iteration
continues with the next iteration

Both can be used in for, while and unitl

END
echo end of introduction 

if [[ ! $1 ]]; then
  echo "Need first argument" >&2
  exit 1
fi

found=""
#red upto first match
while read -r || [[ $REPLY ]]; do    #when read -r reach false, the last line reply actually contain a content
  if [[ ! $found ]]; then
    if [[ $REPLY =~ $1 ]];then
      found="yep"
    else
      continue
    fi
  fi
done

#just print the rest of the file
while read -r || [[ $REPLY ]]; do
  echo "$REPLY"
done

exit 0

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


# outputs a line of characters
#first argument: length of line
#second argument: character, will default to "-" if none given

if [[ ! $1 ]]; then
  echo "Need line length argument" >&2
  exit 1
fi

#check that first argument is a number
if [[ $1 =~ ^[0-9]+$ ]]; then
  length="$1"
else
  echo "Length has to be a number" >&2
  exit 1
fi

char="="
if [[ $2 ]]; then
  char="$2"
fi

line=
for (( i=0; i<length; ++i )); do
  line="${line}${char}"
done

printf "%s\n"  "$line"
exit 0


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

END
echo end of introduction 


# Example change filename extensions

if [[ $# -ne 2 ]]; then
  echo "Need exactly two arguments"
fi

for f in *"$1";do
  echo $f
  base=$(basename "$f" "$1")
  mv "$f" "${base}$2"
done

# while read -r; do
#   printf "%s\n" "$REPLY"
# done <"$1"


#!/bin/bash
# A simple guessing game
#Get a random number < 100
target=$(($RANDOM % 100))

echo $target
#initialize the user's guess

guess=

until [[ $guess -eq $target ]];do
  read -p "Take a guess: " guess
  if [[ $guess -lt $target ]]; then
    echo "Higher!"
  elif [[ $guess -gt $target ]]; then 
    echo "Lower!"
  else
    echo "You found it!"
  fi
done

exit 0


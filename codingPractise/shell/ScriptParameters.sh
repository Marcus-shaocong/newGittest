#!/bin/bash


echo script parameters introduction 
:<<'END'

======Special Variables 1=======
1. Positional Parameters
  Hold the n-th command line argument:$1,$2,etc.
  Above 9 use braces:${10}, ${25}

2. $0
  Holds name of the script as it was called

3. $@: All
  Equivalent to $1 $2 $3 ... $N
  But when double quoted:"$1" "$2" "$3" ... "$N"
  so parrameters multiple words stay intact

4. $*
  Equivalent to $1 $2 $3 ...$N
  But when double quoted: "$1 $2 $3 ...$N"
  Don't use this; use $@ instead!
  
5. $#
  Holds the number of arguments passed to the script  

===============Shift===============
removes the first argument
all positional parameters shift
$2 -> $1
$3 -> $2
$4 -> $3
etc.

$@ lowered by 1

Give a number to shift multiple:
  shift 3 removes the first three arguments


END
echo end of introduction 

# printargs "first arg" second third 
for a in "$@"; do    #add a "quote to $@"
  echo $a;
done

for a in $a; do 
  echo $a;
done


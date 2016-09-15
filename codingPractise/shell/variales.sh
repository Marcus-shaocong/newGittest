#!/bin/bash


echo Varables declaration 
:<<'END'

======Integer Variables=======
Integer variables
  declare -i num
  Now $num can only hold numbers
  Trying to set it to something else will NOT give an error
  Instead, this will set a value of 0

Using an attribute with +
declare +i num

Triggers arithmetic evaluation

Arithmetic Expressions
C-like syntax for doing calculations
let command
  let n=100/2
(( .. ))
  ((++x))
  ((p=x/100))
  ((p=$(ls | wc -l) *10 ))
  this is a command equivalent to let
$((..))
  this is a substitution, not a command
  p=$((x/100))

with a variable declared as an integer

No need to quote variables
((..)) can be used in if,while
0 is false, anything greater than 0 is true
((0)) || echo "false"
Pitfall:numbers with leading zeros are interpreted as octal

=====================Read-Only variables=============
declare -r constant="some value"
Cannot give $constant another value
Bash will report an error

============Exporting variables==============
1. by default variables are local to your script
Or terminal session
2. Export a variable
To make it availabe to subprocesses
you cannot pass a variable to the program that runs your script
3. export var
  export var="value"
4. declare -x var
  declare -x var="value"

END
echo end of introduction 


# Example change filename extensions
declare p
p="4+5"
echo $p

declare -i p
p="4+5"
echo $p

#!/bin/bash
# A simple guessing game
#Get a random number < 100
declare -ir target=$(( ($RANDOM % 100) +1 ))   #declare target as an integer and readonly variable

#Initialize the user's guess
declare -i guess=0
echo $target
#initialize the user's guess

guess=

until (( guess == target ));do
  read -p "Take a guess: " guess
  #if guess is 0, it was not a number
  (( guess )) || continue

  if (( guess < target )); then
    echo "Higher!"
  elif (( guess > target )); then 
    echo "Lower!"
  else
    echo "You found it!"
  fi
done

exit 0



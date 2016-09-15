#!/bin/bash


echo function introduction 
:<<'END'

======functions ======
1. Define your own command
2. name() {...}
  You can run the code in the braces as a new command
  other equivalent syntax (not recommended):
  function name(){...}
  function name{...}

3. Execute it like any command
  Give it arguments
  Use redirection

4. Positional parameters are available for function arguments
  $1, $2, ...

5. Naming your functions
    same rules as for naming scripts: don't override existing commands

6. Bash variables are globally visible
  in a function, you can make a variable local to that function
  use declare or local
7. Exit a function with return
  returns a status code, like exit
  without a return statement, function returns status of last statement

8. Returning any other value
  Use a global variable
  Or send the data to ouput and use command substitution

9 exporting a function
  export -f fun


END
echo end of introduction 

# A function to draw a line
drawline()
{
  declare line=""
  declare char="-"
  for (( i=0; i<$1; ++i ));do
    line="${line}${char}"
  done
  printf "%s\n" "$line"
}

[[ ! $1 ]] && exit 0

declare -i len="${#1} + 4"
drawline len
printf "| %s |\n" "$1"
drawline len

sum() {
  return $(( $1 + $2 ))
}

starts_with_a() {
  [[ $1 == [aA]* ]];
  return $?
}

if starts_with_a ax; then
  echo "yup"
else
  echo "nope"
fi
echo $( sum 4 5 )

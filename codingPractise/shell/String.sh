#!/bin/bash

:<<END
===========Parameter Expansion ==========
Allows powerful string manipulation
%{#var}: length of $var

1. removing part of string
${var#pattern} Removes shortest match from begin of string
${var##pattern} removes longest match from begin of string
${var%pattern} removes shortest match from end of string
${var%%pattern} removes longest match from end of string

Pattern matching is like pathname matching with*, ? and []

Example with i="/Users/reindert/demo.txt"

${i#*/} Users/reindert/demo.txt
${i##*/} demo.txt
${i%.*} /Users/reindert/demo
${i%/*} /Users/reindert

2. Search and Replace
${var/pattern/string}
Substitute first match with string
${var//pattern/string}
Substitute all matches with string

3 Anchor your pattern
${var/#pattern/string} matches beginning of the string
 
${var/%pattern/string} matches end of the string


======================================default Values
1. default value
  ${var:-value}
  will evaluate to "value" if var is empty or unset
  ${var-value}
  Similar, but only if var is unset

2. Assign a default value
  ${var:=value}
  if war was empty or unset, this evaluates to "value" and assigns it to var
  ${var=value}
  Similar, but only if var is unset

=======================================Conditional Expression patterns==========
1. ==, != in [[ ..]] do pattern matching
  == is the same operator as =
  [[ $var == pattern ]] returns true when $var matches the pattern
  Pattern matching is like pathname matching with *, ? and []
  [[$filename == *.txt ]]

2. use quotes to force string matching
  [[ $var == "[0-9]*" ]] matches the string "[0-9]*"

  [[ hello = h*o ]] && echo yep    #echo yep
  [[ hello = "h*o" ]] && echo yep  #would not echo yep
  [[ "h*o" = "h*o" ]] && echo yep  # will echo yep
  [ hello = h*o ] && echo yep      #will not echo yep, don't use this 

END

isnum()
{
  declare -r num_re='^[0-9]+$'
  declare -r octal_re='^0(.+)'
  num_error="ok"
  if [[ $1 =~ $octal_re ]]; then
    if [[ $1 =~ $octal_re ]]; then
      num_error="$1 is not a number, did you mean ${BASH_REMATCH[1]}?"
      return 1
    fi
  else
    num_error="$1 is not a number"
    return 1
  fi

  return 0
}



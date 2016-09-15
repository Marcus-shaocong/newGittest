#!/bin/bash


echo before comment
:<<'END'

Echo 
  prints its arguments to standard output, followed by a new line
  -n suppresses the newline
  -e allows use of escape sequences
    \t:tab
    \b backspace
  These options are not portable to non-bash shells

read
  reads input into a variable
  "read x"
  No variable specified? Will use REPLY
  -n or -N specifies number of characters to read
  -s will suppress output(useful for passwords)
  -r disallows escape sequences, line continuation
  Good habit: always use -a
  several more useful options(see help)
  -r disallows escape sequences, line continuation

  read can read words in a line into multiple variables
  read x y 
  input "1 2 3": x=1, y="2 3"
  Uses IFS variable for delimiters

redirection
Input redirection: <
    grep milk < shoppingnotes.txt
Output redirectoion: >
  ls > listing.txt
  Will overwrite existing files!

redirect a specific stream with N>
  "cmd 2>/dev/null" discards all stderr errors
redirect to a specific stream with >&N
  >&2 sends output to stderr(equivalent to 1>&2)
  2>&1 redirects stderrr into stdout
sending both rror and output to a single file
  cmd > logfile 2>&1
  Don't do this: cmd >logfile 2> logfile
  Don't use &> or >&

Allowed anywhere on the command line, but order matters
cmd>logfile 2>&1 (sends errors to the logfile)
  2>&1 > logfile cmd (sends errors to stdout)
END
echo after comment


echo -n "Are you sure (Y/N)?"

answered=
while [[ ! $answered ]]; do
  read -r -n 1 -s answer
  if [[ $answer = [Yy] ]]; then
    answered="yes"
  elif [[ $answer = [Nn] ]]; then
    answered="no"
  fi
done

printf "\n%s\n" $answered
IFS=:
read a b

echo $a
echo $b
# read -r
# echo $REPLY



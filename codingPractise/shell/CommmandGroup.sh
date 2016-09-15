#!/bin/bash


echo Control Flow introduction 
:<<'END'

============Command Groups =================
Group commands with {}
will group them into a single statement
Can use I/O redirection for the whole group
Use the group in an if statement or while loop
Return status is that of the last command in the group

{cmd1; cmd2; cmd3;}
Separate the commands with newlines or semicolons
use spaces around braces

======================|| and && =============
&&
  will execute next statement only if previous one succeeded
  mkdir newdir && cd newdir
||
  Will execute next statement only if previous one failed
  [[ $1 ]] || echo "missing argument" >&2


[[ $1 ]] || echo "missing argument" >&2 && exit 1
  !!Dont do this: will always exit!
  [[$1]] || {echo "missing argument" >&2; exit 1;}

END
echo end of introduction 

[[ $# -ne 2 ]] && { echo "Need exactly two arguments" >&2;}


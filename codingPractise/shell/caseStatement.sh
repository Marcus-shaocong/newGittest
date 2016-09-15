#!/bin/bash 


echo Case statement 
:<<'END'
case WORD in 
  PATTERN1)
    code for pattern 1;;
  PATTERN1)
    code for pattern 1;;
  ...
  PATTERNn)
    code for pattern n;;
esac

Matches word with patterns
Pattern matching is the same as with matching filename patterns
use *,?,[]
code for first pattern that matches gets executed
end code with;;
so you can ue multiple statements separated by;
END
echo case statement 

# case $1 in 
#   cat)
#     echo "meow";;
#   dog)
#     echo "woof";;
#   cow)
#     echo "mooo";;
#   *)
#     echo "unknown animal";;
# esac

# exit 0



#Script that tries to handle tar commands in an intelligent way
#Disclaimer: this is a demo for the case statement, not a production-ready script!
#Use: mytar dir file
#this will compress the directory dir into file
set -x
if [[ ! $1 ]]; then
  echo "Need a file or directory aas first argument" >&2
  exit 1
fi

if [[ -d $1 ]]; then
  #Is a directory : create archive
  operation="c"
  if [[ ! $2 ]]; then
    echo "Need name of file or directory to create as second argument" >&2
    exit 1
  fi
  tarfile="$2"
  dir="$1"
else
  #Is (probably) a file: try to extract
  operation="x"
  tarfile="$1"
  dir=""
fi
set +x
case $tarfile in
  *.tgz|*.gz|*.gzip)
    zip="z"
    echo "Using gzip" >&2;;
  *.bz|*.bz2|*.bzip|*.bzip2)
    zip="j"
    echo "Using bzip2" <&2;;
  *.Z) 
    zip="Z"
    echo "Using compress" <&2;;
  *.tar)
    zip=""
    echo "No compression used" >&2;;
  *)
    echo "Unknown extension: ${tarfile}" >&2
    exit 3;;
esac

command="tar  ${operation}${zip}f $tarfile"
if [[ $dir ]]; then
  command="${command} $dir"
fi

if ! $command; then
  echo "Error: tar exited with status $?" >&2
  exit 4
fi

echo "Ok" >&2
exit 0





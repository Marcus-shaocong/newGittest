#!/bin/bash


echo GetOpts introduction 
:<<'END'

======Special Variables 1=======
1. Utility to help parse argument lists
  i. Expects options to start with a dash(-x)
  ii. Allows options that take an argument (-f file)
2. getopts optstring name
3. optstring
  i. A list of expected options
  ii. "ab" will let your script handle an option -a and/or -b
  iii. Append: to options that take an argument
  iiii. "a:b" will let a take an argument, but not b
4. name
  1. the name of a variable
  2. Every time you call getopts, it will place the next option into $name
5. getopts returns false when no more options are left

6. Any word not starting with a dash will end option processing
  so anyting after the options, you have to parse for yourself
  -x -y file1 file2 file3
  An option "--" will be seen as the end of options as well

7. Arguments for options will be put in OPTARG
8 OPTIND holds the index of the next argument to be processed


==============================Getopts :handling errors=======
Default: not-silent mode
getopts handles errors for you
if anythign goes wrong, the option variable NAME holds "?"

Process errors by yourself
  start option string with a colon (silent mode)
  ":b:s:r"

Unknow option:
    "?" in option variable NAME
    actual option in OPTARG

Missing option argument:
    ":" in option variable NAME
    actual option in OPTARG
END
echo end of introduction 


# This script prints a range of number
# Usage : count [-r] [-b n] [-s n] stop
# -b gives the number to begin with (default:0)
# -r reverses the count
# -s sets step size (default: 1)
# counting will stop at stop


usage()
{
cat <<END
 Usage : count [-r] [-b n] [-s n] stop
 -b gives the number to begin with (default:0)
 -r reverses the count
 -s sets step size (default: 1)
 counting will stop at stop
END
}

error()
{
  echo "Error: $1"
  usage
  exit $2
} >&2

isnum()
{
  [[ $1 =~ ^[0-9]+$ ]]
}
declare reverse=""
declare -i begin=0
declare -i step=1

while getopts ":hb:s:r" opt; do    #":b:s:r" start with colon, that means user want to handler error himself
  case $opt in 
    r)
      reverse="yes"
      ;;
    b)
      isnum ${OPTARG} || error "${OPTARG} is not a number" 1
      start="${OPTARG}"
      ;;
    s)
      [[ ${OPTARG} =~ ^[0-9]+$ ]] || error "${OPTARG} is not a number" 1
      step="${OPTARG}"
      ;;
    h)
      usage
      exit 0 
      ;;
    :)
      error "Option -${OPTARG} is missing an argument" 2
      exit 1
      ;;
    \?) #to handle an unknown optons, beasue "?" will be put in the optional variable NAME
      error "Unknown option: -${OPTARG} " 3 
      exit 1
      ;;
  esac
done

#OPTIND holds the index of the next argument to be processed
shift $(( OPTIND -1 ))

#$1 now is a stop argument
[[ $1 ]] || { echo "missing an argument" >&2; exit 1; }
declare end="$1"

if [[ ! $reverse ]]; then 
  for (( i=start; i <= end; i+=step )); do
    echo $i
  done
else
  for (( i=end; i >= start; i-=step )); do
    echo $i
  done
  
fi

exit 0


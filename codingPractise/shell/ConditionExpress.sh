
# Conditional Expressions 2
# use "help test" to check the conditional expression 
# " help [["


#Return codes
# 0 = succes, every thing else failure


# Arithmetic tests
# For comparing integers only
# [[ arg1 OP arg2 ]]
# Where OP is:

#-eq: equality
#-ne: not equal
#-lt: less than
#-gt: greater than
#And some others.. see hlep
#So don't use=,>,< for uumbers!

#Special variables:
#$# contains number of script arguments
#$? contains exit status for last command

# Use ! to negate a test:
# [[ ! -e $file ]]
# Use spaces around!

#Use && for "and":
# [[ $# -eq 1 && $1 = "foo" ]]

#Use || for "or"
# [[ $a || $b ]]

#Don't use -a, -o for and, or


if [[ $# -ne 2 ]]; then
  echo "Need exactly two arguments"
  exit 1
fi

length_1=${#1}    #get the length of first argument
length_2=${#2}

#which one has most files?
if [[ $length_1 -gt $length_2 ]]; then
  echo "$1 is longest"
elif [[ $length_1 -eq $lengt_2 ]]; then
  echo "length is equal"
else
  echo "$2 is longest"
fi

if [[ ! -d $1 ]]; then
  echo "'$1' is not a directory"
  exit 1
fi

if [[ ! -d $2 ]]; then
  echo "'$2' is not a directory"
  exit 1
fi

dir1="$1"

echo "length of dir is ${#dir1}"
dir2="$2"
#Get number of files in directories
count_1=$(ls -A1 "$dir1" | wc -l)
count_2=$(ls -A1 "$dir2" | wc -l)

#Which one has most files?
if [[ $count_1 -gt $count_2 ]]; then
  echo "${dir1} has most files"
elif [[ $count_1 -eq $count_2 ]]; then
  echo "number of files is equal"
else
  echo "${dir2} has most files"
fi

exit 0



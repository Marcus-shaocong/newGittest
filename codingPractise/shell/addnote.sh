#!/bin/bash

# Return codes
# Value return


#Conditionl expressions
# [[ Expression ]]
#
# Expression                  | True if
# [[ $str ]]                  |  str is not empty
# [[ $str = "something" ]]    |  str equals string "something" 
# [[ $str="something" ]]      |  always returns true!
# [[ -e $filename ]]          |  file $filename exists
# [[ -d $dirname ]]           |  $dirname is a directory

#spaces around the expression are very import, same for switches (-e) and equals sign

#simple -note-taking script

#get the date
declare -r date=$(date)

#get the topic
declare -r topic="$1"

#determine where to save our notes
declare notesdir="${HOME}"
[[ $NOTESDIR ]] && notesdir="${NOTESDIR}"

if [[ ! -d $notesdir ]]; then
  mkdir "${notesdiir}" 2> /dev/null || { echo "Cannot make directory ${notesdir}" 1>&2; exit 1; }
fi

#filename to write to
declare -r filename="${notesdir}/${topic}notes.txt"

if [[ ! -f $filename ]]; then
  touch "${filename}" 2> /dev/null || { echo "Cannot create file ${filename}" 1>&2; exit 1; }
fi

#is file writeable?
[[ -w $filename ]] || { echo "${filename} is not writeable" 1>&2; exit 1; }

#Ask user for input
read -p "Yout note: " note

echo "$date:$note" >> "$filename"
echo "Note 'note' saved to $filename"

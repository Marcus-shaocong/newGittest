
#Is there an argument?
if [[ ! $1 ]]; then
  echo "Missing argument"
  exit 1
fi

declare open_editor=""
if [[ $# -eq 1 ]];then
  open_editor="true"
fi

scriptname="$1"
declare -r bindir="${HOME}/bin"



#Check bin directory exists
if [[ ! -d $bindir ]]; then
  #if not : create bin directory
  if mkdir "$bindir"; then
    echo "created ${bindir}"
  else
    echo "Could not create ${bindir}."
    exit 1
  fi
fi

#the shift demo
while [[ $1 ]]; do
  scriptname="$1"
  filename="${bindir}/$scriptname"

  if [[ -e $filename ]];then
    echo "File ${filename} already exists" >&2
    shift
    continue
  fi

  if type "$scriptname" > /dev/null 2>&1; then
    echo "There is already a command with name ${scriptname}" >&2
    shift
    continue
  fi

  #Create a script with a single line
  echo '#!/bin/bash' > "$filename"
  #Add executable permission
  chmod u+x "$filename"
  #Open with editor
done


if [[ $open_editor ]];then
  echo opening
  if [[ $EDITOR ]]; then
    $EDITOR "$filename"
  else
    echo "Script screated: not starting editor because \$EDITOR is not set."
fi

echo "End of code reached"
exit 0

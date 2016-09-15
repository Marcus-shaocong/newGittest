
:<<END

1. Background and nohup

nohup myscript &

Run your script with a lower priority
nohup nice myscript

Redirect I/O for the whole script
Useful for logging
exec >logfile 2>errorlog

2.At
  will execute your script at aspecific time
  at -f myscript non tomorrow

3. Cron
  Will execute your script according to a achedule
  on Mac OS, use lanuchd

4.  set and short
customize bash behaviour with set and shopt
set
 -x prints each command with its arguments as it is executed
 -u gives an error when using an uninitizlied variable and exits script
 -n read commands but do not execute
 -v print each command as it it read
 -e exits script whenever a command fails(but not with if, while, until, ||, &&)
 ... and more
 
shopt
 can set many options with -s, unset with -u
 shopt -s nocaseglob: Ignore case with pathname expansion
 shopt -s extglob: Enable extended pattern matching
 shopt -s dotglob: include hidden files with pathname expansion
 set -o noclobber: Don't overwrite files on redirection operations.

END

#!/bin/bash
#command to run the script in background: nohup myscript > log &

if [[ $1 == "-l" ]]; then
  exec >logfile
fi

declare -i i=0
while true; do
  echo "Still here $((++i))"
  sleep 1
done



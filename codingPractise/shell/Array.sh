#!/bin/bash


echo Array introduction 
:<<'END'

======Array=======
1. An array can hold multiple values
  Stored and retrieved by index
2. Storing a value
  x[0]="some"
  x[1]="word"
3. Retrieving a value
  ${x[0]} : some
  ${x[1]} : word
  ${x[@]} or ${x[*]} retrieve all values(quoting works like $*, $@)
4. declare -a x
  Or simply assign with an index like above
5. Initializing an array:
  ar=( 1 2 3 a b c )

6. Count the number of elements in $array
  ${#array[2]}
7. The indices in $array
  ${!array[@]}
  there can be gaps in the indices

8. You cannot export an array
9. Bash 4 supports associative arrays
  where elements are stored and retrieved by a name, not an index
  declare -A array
END
echo end of introduction 

ar=(this is an array)
ar[15]=something

for (( i=0; i<${#ar[@]}; i++ ));do
  echo ${ar[$i]}
done




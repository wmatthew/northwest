#!/bin/bash
#
# Reformat output from sorterRun.rb (into JSON)
# Move it from a .txt file to a .js file.

function usage {
  echo 'Usage: '
  echo '> format.sh [cols|pair] size'
  exit
}

if [ "$1" != "cols" ] && [ "$1" != "pair" ]; then
  echo "First argument must be 'cols' or 'pair'."
  usage
fi

if ! [[ "$2" =~ ^[0-9]+$ ]] || [ "$2" -gt 12 ] || [ "$2" -lt 0 ]; then
  echo "Second argument must be an integer."
  usage
fi

src="$1/$1_$2.txt"
dest="$1/$1_$2.js"

echo "Moving from $src to $dest"

echo "// $1_$2: list of all losing states in $2x$2 northwest game." > $dest
echo "var $1_$2 = [" >> $dest;
grep ',' $src >> $dest
echo '];' >> $dest





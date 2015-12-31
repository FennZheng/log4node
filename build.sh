#!/bin/bash

# node 0.8.6

SRC=./

echo "Compile source code..."
# compile all .coffee files under ./SRC to .js
coffee -c -o . $SRC
if [ $? -ne 0 ]; then
  echo "Compile log4node fail."
  exit 1
fi

echo "Success for build log4node."
exit 0

for file in `ls $SRC`
    do
        if [ -d $SRC"/"$file ]
        then
            batch_convert $SRC"/"$file
        else
            dos2unix $SRC"/"$file
            #echo $1"/"$file
        fi
    done
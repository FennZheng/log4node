#!/bin/bash

# node0.11.14
export PATH=/usr/local/node11/bin:$PATH

SRC=./
SETTING_DEFAULT=setting.default

# clean old version
echo "Clean old build output..."
rm -fr output

# copy all none-coffee files under SRC to target directory
echo "Compile source code..."
for f in `cd $SRC;find . -type f | grep -v ".coffee"`;
do
	dirname=`dirname $f`;
	mkdir -p $dirname;
	cp ${SRC}/${f} $dirname;
done

# compile all .coffee files under ./SRC to .js
coffee -c -o . $SRC
if [ $? -ne 0 ]; then
  echo "Compile log4node fail."
  exit 1
fi

echo "Success for build log4node."
exit 0
#!/usr/bin/env zsh

curl -s "https://github.com""$1" \
 |
jq '.payload.blob.rawBlob' \
 |
sed -e 's/\("\)/strFD=\1/1' > strungFile.py

#$ echo "${PATH//\:/\\n}"
python -c 'from strungFile import *;print(strFD)' > ${1//\//_}


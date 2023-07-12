#!/usr/bin/env zsh


curl -s \
 "https://github.com/EAS-Rhys/es-stu/blob/main/settings.gradle" \
 |
jq '.payload.blob.rawBlob' \
 |
sed -e 's/\("\)/strFD=\1/1' > strungFile.py

python -c 'from strungFile import *;print(strFD)' > FinalForm.gradle

echo "FinalForm.gradle"


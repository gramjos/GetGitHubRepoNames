#!/usr/bin/env zsh

trap "rm -f strFD.py" EXIT


# magicLink
magicLink="https://github.com/"$1
curl -s "$magicLink" \
 | # two separate key names found that contain raw file info
jq -r '.payload.blob | [.rawLines, .rawGlob] | add' \
 | # add variable declaration at beginning of line
sed -e '1 s/\[/arrFile=[/' > strFD.py

python -c 'from strFD import *;_=[print(i) for i in arrFile]' > ${1:t}

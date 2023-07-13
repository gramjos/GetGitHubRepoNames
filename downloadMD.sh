curl -s "https://github.com""$1" \
|
jq '.payload.blob.richText' \
|
sed -e 's/\(^"\)\(.*\)\("$\)/strFD="\2"/'
#sed -e 's/\(^"\)\(.*\)\("$\)/\2/'

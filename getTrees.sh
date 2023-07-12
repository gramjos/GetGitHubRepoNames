#!/usr/bin/env zsh

# displays the contents of given repo and 1 level below 
# TODO pretty print the output.
#set -x 
uName="$1";
repo="$2";

href_links=()
for match in $(
  curl -s "https://github.com/"$1"/"$2 | 
    perl -ne 'print "$1\n" if 
      /class="js-navigation-open Link--primary".* href="(\/'$1'\/'$2'\/[^"]*)"[^>]*>([^<]*)(.*)/'
			  )
  do
    href_links+=($match)
done
# "${href_links[@]}" entire array
for item in "${href_links[@]}"; do
  command="curl -s 'https://github.com'$item | jq '.payload.tree.items[] | .name'"
  # curl calls directly to directories within a repo returns JSON. 
    # jq translation, within the payload obj there is a tree obj that contains a list called items and
    # one of the attributes within this list is 'name'

  # the below cammand returns a return error code of 5 when called with a file link, instead of a 
  # directory link 
  cc=$(eval $command 2> /dev/null)
  isFileEr=$?
  case "$isFileEr" in 
    5) echo "File: "$item 
        ;; 
    0) echo 'Directory ' ${item##*/} ' contains:'  ;
       cc_clean=$(echo $cc | tr -d '"'| paste -s -d " " -); 
       echo "\t"$cc_clean; 
      ;; 
    *) echo "error with "$isFileEr 
      ;; 
  esac 
done 

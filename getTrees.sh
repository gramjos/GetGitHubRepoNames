#!/usr/bin/env zsh

uName="$1";
repo="$2";

# Store the matches in an array.
href_links=()
for match in $(
  curl -s "https://github.com/"$1"/"$2 | 
    perl -ne 'print "$1\n" if 
      /class="js-navigation-open Link--primary".* href="(\/'$1'\/'$2'\/[^"]*)"[^>]*>([^<]*)(.*)/'
			  )
  do
    href_links+=($match)
done

# Print the array.
#echo "${href_links[@]}"
#
## are these links directories or files
# if( isFile(link) )
# 		# leaf so do nada
# else
# 		display contents of this directory

for item in "${href_links[@]}"; do
  command="curl -s 'https://github.com'$item | jq '.payload.tree.items[] | .name'"
  cc=$(eval $command 2> /dev/null)
  isFileEr=$?
#  echo $isFileEr ; 
  if [[ "$isFileEr" -eq "0" ]];then
  	echo 'Items inside of ' $item ' are below.. ' ; 
	echo $cc;
  else
    echo $item ' is a file'
	  fi
  printf "\n"
done


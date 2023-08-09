#!/usr/bin/env zsh

gitUser=$1
gitRepo=$2
getFlag=1
github="https://github.com"
USAGE=$(cat <<-useStatmt
░░░░  this program needs two args   ░░░░
    Usage Statement
$ ./reposFiles [GitHub Username] [Repository Name]
useStatmt
)

usage_statement(){
  case "$1" in
    "args") printf "%s\n" $USAGE
     ;; 
    "uName") echo " Invalid user name or repo. Is repo public?"
     ;; 
    *) echo "Unknown error fetching user or user's repo..."
     ;; 
  esac 
  exit 1
}

getFileSelect(){
 menuHeader="Select a file to download or a path to explore add dir name"
 selected=$(echo $1 | tr ' ' '\n' |fzf --header $menuHeader)
 selErr=$?
 magicLink=$2"/"$selected
 echo "you selected "$selected  "here is the magic link "$magicLink
 [[ "$selErr" == 0 ]] && source ./downloadFile.sh $magicLink
}

getFile(){
  echo "Download file "$1 " ??" 
  read "respon?Confirm (Y)es (N)o or (E)xit " 
  case "$respon" in
  	[yY]) echo " you selected yes to down load"
		      source ./downloadFile.sh  $1
		 ;;
    [eE])	echo "stopping the ask prompt"
          exit; 
     ;; 
    [nN])	echo "Not this file..."
     ;; 
    *)	echo " NO get got unknown response "$respon 
     ;; 
	esac
}

echo "Checking the contents of "$gitRepo" by "$gitUser
case "$#" in
  2) echo "viewing only"
   ;; 
  3) echo "Option to GETT!"
     [[ "$3" == "-g" ]] && getFlag=0
   ;; 
  *) usage_statement "args"
   ;;
  esac 
class='class="js-navigation-open Link--primary"'
pattern=$class'.* href="(\/'$gitUser'\/'$gitRepo'\/[^"]*)"[^>]*>([^<]*)(.*)'
export pattern
for item in $(
		curl -s $github"/"$gitUser"/"$gitRepo \
		| \
		perl -ne 'print "$1\n" if /$ENV{pattern}/'
			  ) ; do

  cc=$(curl -s $github"/"$item | jq '.payload.tree.items[] | .name' 2> /dev/null)
  isFileEr=$?
  case "$isFileEr" in 
    5) echo "File: "${item:t} 
       [[ $getFlag -eq 0 ]] && getFile $item 
      ;; 
    0) cc_clean=$(echo $cc | tr -d '"'| paste -s -d " " -)
       item=$(echo $item |sed 's/tree/blob/')
       echo 'Directory ' ${item##*/} ' contains: '$cc_clean
       [[ $getFlag -eq 0 ]] && getFileSelect $cc_clean $item
      ;; 
    *) echo "error with "$isFileEr 
      ;; 
  esac 
done
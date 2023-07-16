#!/usr/bin/env zsh

gitUser=$1
gitRepo=$2
getFlag=1
github="https://github.com/"
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
    *) echo "where error?"
       ;; 
  esac 
  exit 1
}

getFileSelect(){
  echo "what to download from this list "$1 "?" 
  # echo "if a dir is chosen just get its contents"
 menuHeader="Select a file to download or a path to explore"
 selected=$(echo $1 | tr ' ' '\n' |fzf --header $menuHeader)
 echo "you selected "$selected 
 [[ -z $selected ]] && source ./downloadFile.sh $2
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

pattern='class="js-navigation-open Link--primary".* href="(\/'$gitUser'\/'$gitRepo'\/[^"]*)"[^>]*>([^<]*)(.*)'
export pattern
for item in $(
		curl -s $github$gitUser"/"$gitRepo \
		| \
		perl -ne 'print "$1\n" if /$ENV{pattern}/'
			  ) ; do

  magicLink=$github$item
  cc=$(curl -s $magicLink | jq '.payload.tree.items[] | .name' 2> /dev/null)
  isFileEr=$?
  case "$isFileEr" in 
    5) echo "File: "${item:t} 
       [[ $getFlag -eq 0 ]] && getFile $item 
      ;; 
    0) cc_clean=$(echo $cc | tr -d '"'| paste -s -d " " -)
       echo 'Directory ' ${item##*/} ' contains: '$cc_clean
       [[ $getFlag -eq 0 ]] && getFileSelect $cc_clean $magicLink
       ;; 
    *) echo "error with "$isFileEr 
      ;; 
  esac 
done
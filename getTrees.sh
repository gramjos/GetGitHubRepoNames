#!/usr/bin/env zsh

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
  echo "what to download from this list "$1 " ??" 
  # echo "if a dir is chosen just get its contents"
  # use fzf to search trhu list, also do a posix version
  
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
    *)	echo " NO get by unknown response "$respon 
    ;; 
	esac
}

echo "Checking the contents of "$2" by "$1
case "$#" in
  2) echo "viewing only"
  ;; 
  3) echo "Option to GETT!"
     [[ "$3" == "-g" ]] && getFlag=0
  ;; 
  *) usage_statement "args"
  ;;
  esac 

pattern='class="js-navigation-open Link--primary".* href="(\/'$1'\/'$2'\/[^"]*)"[^>]*>([^<]*)(.*)'
export pattern
for item in $(
		curl -s $github$1"/"$2 | perl -ne 'print "$1\n" if /$ENV{pattern}/'
			  ) ; do
  cc=$(curl -s $github$item | jq '.payload.tree.items[] | .name' 2> /dev/null)
  isFileEr=$?
  case "$isFileEr" in 
    5) echo "File: "${item:t} 
       [[ $getFlag -eq 0 ]] && getFile $item 
    ;; 
    0) cc_clean=$(echo $cc | tr -d '"'| paste -s -d " " -)
       echo 'Directory ' ${item##*/} ' contains: '$cc_clean
       [[ $getFlag -eq 0 ]] && getFileSelect $cc_clean 
    ;; 
    *) echo "error with "$isFileEr 
    ;; 
  esac 
done

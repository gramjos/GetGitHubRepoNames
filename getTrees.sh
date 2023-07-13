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
  echo "if a dir is chosen just get its contents"
  # use fzf to search trhu list
  
}
getFile(){
  echo "Download file "$1 " ??" 
  read "respon?Confirm Y or N " 
  echo $respon 
  case "$respon" in
  	[yY]) echo " you selected yes to down load"
		  source ./downloadFile.sh  $1
		;;
	[eE])	echo "stopping the ask prompt"
		;; 
	*)	echo " NO get"
		;; 
	esac
}

#(( "$#" >= 2 )) && usage_statement "args"
case "$#" in
  2) echo "printing only"
    ;; 
  3) echo "getting!"
     [[ "$3" == "-g" ]] && getFlag=0
    ;; 
  *) usage_statement "args"
    ;;
  esac 

href_links=()
for match in $( curl -s $github$1"/"$2 | perl -ne 'print "$1\n" if 
/class="js-navigation-open Link--primary".* href="(\/'$1'\/'$2'\/[^"]*)"[^>]*>([^<]*)(.*)/'
			  ) ; do
    href_links+=($match)
done
[[ -z ${href_links[*]} ]] && usage_statement "uName"

for item in "${href_links[@]}"; do
  command="curl -s $github$item | jq '.payload.tree.items[] | .name'"
  cc=$(eval $command 2> /dev/null)
  isFileEr=$?
  case "$isFileEr" in 
    5) echo "File: "${item:t} 
    # ask if user wants to get file. 
    [[ $getFlag -eq 0 ]] && getFile $item 
# if get file returns err
        ;; 
    0) echo 'Directory ' ${item##*/} ' contains:'  
       cc_clean=$(echo $cc | tr -d '"'| paste -s -d " " -)
       echo "\t"$cc_clean;
       # ask here if you want to get from the dir above
    [[ $getFlag -eq 0 ]] && getFileSelect $cc_clean 
      ;; 
    *) echo "error with "$isFileEr 
      ;; 
  esac 
  done 

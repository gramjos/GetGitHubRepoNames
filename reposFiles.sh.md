# A Walk Through 
```shell
#!/usr/bin/env zsh
```
- the above directive is more portable b/c from an 'env' 
- zsh can be found in the user default current environment 

```shell
usage_statement(){
# a 'here doc' string inside a command substitution
	USAGE=$(cat <<-END
░░░░  this program needs two args   ░░░░
    Usage Statement
🌀 listRepoFiles [GitHub Username] [Repository Name]
END
)
	printf "%s\n" $USAGE;
}

listRepoFiles() {
	if [[ "$#" != 2 ]]; then
		usage_statement;
		exit 1;
	fi

	GitHubUserName=$1;
	url_stub="https://github.com/";
	repo_name=$2;
	f_slash="/";
	repoURL=$url_stub$GitHubUserName$f_slash$repo_name

	echo $repoURL 
}
 ```
array list of command line args

```shell
listRepoFiles "$@"; 
 ```

  the 'a' tags that contain the items in the first directory of the repo:

 ```shell 
 <a class="js-navigation-open Link--primary" title="VOpen.applescript" data-pjax="#repo-content-pjax-container" data-turbo-frame="repo-content-turbo-frame" href="/gramjos/vopen/blob/master/VOpen.applescript">VOpen.applescript</a>
<a class="js-navigation-open Link--primary" title="ABOUTS" data-pjax="#repo-content-pjax-container" data-turbo-frame="repo-content-turbo-frame" href="/gramjos/vopen/blob/master/ABOUTS">ABOUTS</a>
```

- what is unique?
```html
 		class="js-navigation-open Link--primary"
 ```


scope allows accesing 
#echo $repoURL; 
	curl $repoURL 2> /dev/null | \
		awk -F">|<" 	\
 row field separator
	'$0 ~ /class="js-navigation-open Link--primary"/ {print $5}';

 match group 1 captures the innerHTML
 [[repoName.sh]]
[[repoNameFiles.sh]]
[[searchrepo.sh]]
		'$0 ~ /class="js-navigation-open Link--primary"[^>]*>([^<]*)(.*)/ {print $5}';

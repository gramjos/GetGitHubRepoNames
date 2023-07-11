## Scraping Github with Bash and Zsh
In a previous version of this script, back in my bash beginnings, functionality only inlcuded displaying the public facing repositories of a given user. The below graphic  illustrates this in two commands:<br>
- `cat repoName.sh`
  - verfiying what will be executed
- `source repoName.sh && listRepos`
  - import file into the current bash shell environment & run

<p align="center">
  <img 
    src="https://media.giphy.com/media/QS6nYlQUgstr48Jyb7/giphy.gif"
	alt="demo_gif"
  />
</p>

### Searching a layer deeper
The zsh file `reposFiles.sh` has two parameters **[Github Username] [Repository Name]** display the contents of the repository. <br>

- The graphic below assumes: 
  - the file is executable 
  - in current directory
  - There is a Github user named gramjos
  - This Github user has a *Public* Repository called tour_co
<p align="center">
  <img 
    src="https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExczJqZTFtYXhsODhpbGduZGJkMWZvaDhrNnpvZDF2dm9hcjhxc214dyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/ozPuTxjCDIyG98QcMj/giphy.gif"
	alt="demo_gif"
  />
</p>
Friendly usage statment displayed when arguments are inadequate. 
<p align="center">
  <img 
    src="https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExa3pvdzV6YW90b3ZoN200am5kMmcxeTBtbzVjbmhoZXk5bGdmcjF2YSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/A3ocU9Y7H6bV8yMBrR/giphy.gif"
	alt="demo_gif"
  />
</p>

#### Below is the entirity of the script

```shell
#!/usr/bin/env zsh

usage_statement(){
	USAGE=$(cat <<-END
░░░░  this program needs two args   ░░░░
    Usage Statement
$ ./reposFiles [GitHub Username] [Repository Name]
END
)
	printf "%s\n" $USAGE;
}

if [[ "$#" != 2 ]]; then
	usage_statement;
	exit 1;
fi

curl -s "https://github.com/"$1"/"$2 |\
	awk -F">|<" '$0 ~ /class="js-navigation-open Link--primary"/ {print $5}';

```

##### When the awk command recives the raw HTML
<p style="color:red;">The nature of `awk` is a line by line parser. So question becomes, what sequence of characters can be searched for that is uniquely shared between the desired lines. The desired lines have directory and file information that will be eventually printed to the screen.</p>
Within the single quotes in the command below, sets up a regular expression that matches the pattern between the forward slashes. `$0` repersents the whole line and the tilde `~` operator specifies regular expression matching. So, one can wrap the previous two statements together by saying, as `awk` takes its line by line input, it is searching for the exact string `class="js-navigation-open Link--primary"` <br>
Aside,`-F` flag for field separator pattern. How a matched is segmented/grouped. Either, the opening or closing character of and opening or closing tag. 

```shell
awk -F">|<" '$0 ~ /class="js-navigation-open Link--primary"/ {print $5}';

```

The block of HTML below is an example of a  successful match. A successful match outputs the entire line. The line is then delineated by the specified field separator. The fifth field contains the sought after data and denoted with `print $5`.

```shell
<a class="js-navigation-open Link--primary" title="ABOUTS" data-pjax="#repo-content-pjax-container" data-turbo-frame="repo-content-turbo-frame" href="/gramjos/vopen/blob/master/ABOUTS">ABOUTS</a>
```

#### Further Regex Experiments with Perl
Given HTML structure, *most likely* any match with this pattern will occur within an achor tag. 

```html
<a>  </a>
```

The greater than (>) is explicitly matched for and the capture begins. Before the first and only capture groups starts consuming characters, the negated character class `[^>]*` and greedy modifier will consumer everything that is not a greater than sign.   <br>



```shell
$ curl -s "https://github.com/gramjos/tour_co" | 
     perl -ne 'print "$1\n" 
        if /class="js-navigation-open Link--primary"[^>]*>([^<]*)(.*)/'
android
assets
ios
lib
linux
macos
test
web
windows
.gitignore
.metadata
README.md
analysis_options.yaml
pubspec.lock
pubspec.yaml
```

TODO
option to recursively download from root(file or directory)

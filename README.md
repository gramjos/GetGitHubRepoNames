> TLDR;<br> Perl and Awk regular expressions to parse HTML

## Scraping Github with Bash and Zsh

### Repository Table of Contents - Script Evolution 

| Epoch | File               |                  Purpose                  | Lines of Code |
| :---: | ------------------ | :---------------------------------------: | :-----------: |
|   1   | `listRepos.sh `    |   Get public repos from given username    |       8       |
|   2   | `reposFiles.sh `   | List the contents of repos (1 level deep) |      15       |
|   3   | `getTree.sh`       | Explore repo and download selected files  |      ~80     |
|  3.5  | `downloadFile.sh ` |      Helper function for getTrees.sh      |       5       |

### Motivation

An edifying exploration of shell (bash/zsh) scripting because shells are omnipresent.

### Epoch 1

In the earliest version of this script, functionality only included displaying the public facing repositories of a given user. The below graphic illustrates this in two commands:<br>

- `cat repoName.sh`
  - verifying what will be executed
- `source repoName.sh && listRepos`
  - import file into the current bash shell environment & run

<p align="center">
  <img 
    src="https://media.giphy.com/media/QS6nYlQUgstr48Jyb7/giphy.gif"
	alt="demo_gif"
  />
</p>

### Epoch 2 - Searching a layer deeper

The zsh file `reposFiles.sh` has two parameters **[Github Username] [Repository Name]** and displays the contents of the repository. <br>

<p align="center">
  <img 
    src="https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExczJqZTFtYXhsODhpbGduZGJkMWZvaDhrNnpvZDF2dm9hcjhxc214dyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/ozPuTxjCDIyG98QcMj/giphy.gif"
	alt="demo_gif"
  />
</p>
Friendly usage statement displayed when arguments are inadequate. 
<p align="center">
  <img 
    src="https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExa3pvdzV6YW90b3ZoN200am5kMmcxeTBtbzVjbmhoZXk5bGdmcjF2YSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/A3ocU9Y7H6bV8yMBrR/giphy.gif"
	alt="demo_gif"
  />
</p>

#### Below is the entirety of the epoch 2 script

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
### Finding the desired data from the `curl` output is the crux of the this problem...
#### When the awk command receives the raw HTML

The nature of `awk` is a line by line parser. So question becomes, what sequence of characters can be searched for that is uniquely shared between the desired lines. The desired lines have directory and file information that will be eventually printed to the screen.<br>
Within the single quotes, in the command below, sets up a regular expression that matches the pattern between the forward slashes. `$0` represents the whole line and the tilde `~` operator specifies regular expression matching. So, one can wrap the previous two statements together by saying, as `awk` takes its line by line input, it is searching for the exact string `class="js-navigation-open Link--primary"` <br>


```shell
awk -F">|<" '$0 ~ /class="js-navigation-open Link--primary"/ {print $5}';

```

The block of HTML below is an example of a successful match. A successful match outputs the entire line. The line is then delineated by the specified field separator. The fifth field contains the sought after data and denoted with `print $5`.

```shell
<span class="css-truncate css-truncate-target d-block width-fit"><a class="js-navigation-open Link--primary" title="ABOUTS" data-turbo-frame="repo-content-turbo-frame" href="/gramjos/vopen/blob/master/ABOUTS">ABOUTS</a></span>
```


The `-F` flag signifies a field separator pattern. This specifies how a successful matched is segmented/grouped. In this scenario, specify, the opening or (|) closing of an HTML tag (greater than or less than sign).

Given HTML structure, `
<a> </a>
`
<br>
A match with this field separator pattern, `
-F">|<" 
`
<br>
 will occur within any tag (the inner HTML) as well as, the regions specified by `()` in the line below.

 ```html
 ()<(a)>(...)<(/a)>()
 ```

### Epoch 3 - Still under Construction...
#### Further Regex Experiments with Perl
Regarding the Perl regex below, <br>
Aside, syntax requires it be wrapped in forwards slashes ex. `/pattern/`

```shell
$ perl -ne 'print "$1\n" if 
    /class="js-navigation-open Link--primary"[^>]*>([^<]*)(.*)/' raw_html
```

<br>
`class="js-navigation-open Link--primary"[^>]*>([^<]*)(.*)`
<br>
The beginning part of the regex is a literal character match and this part is shown below.
<br>
`class="js-navigation-open Link--primary"`
<br>
The other half contains the meta-characters which activates special functionality and this part is shown below.
<br>
`[^>]*>([^<]*)(.*)` 
<br>
 Capture groups are a way to select a specific part of a regular expression match. They are enclosed in parentheses and referenced by the `$n` notation, where `n` is the group number.  Before the first capture group, the negated character class `[^>]` and it's greedy modifier `*` will consume everything that is not a greater than sign. Then the greater than sign (>) is explicitly matched for and then capturing begins. <br>

```shell
$ curl -s "https://github.com/gramjos/tour_co" |
     perl -ne 'print "$1\n"
        if /class="js-navigation-open Link--primary"[^>]*>([^<]*)(.*)/'
```

**_Example output from the above command_**<br>
android<br>
assets<br>
ios<br>
lib<br>
linux<br>
macos<br>
test<br>
web<br>
windows<br>
.gitignore<br>
.metadata<br>
README.md<br>
analysis_options.yaml<br>
pubspec.lock<br>
pubspec.yaml<br>

### Notes on Github's backend file tree

- tree and blob used inter-changably? not sure about the previous statement. `tree` is used at the repo level, then blob for anything below
  - https://github.com/gramjos/tour_co/`blob`/master/android/settings.gradle
  - https://github.com/gramjos/tour_co/`tree`/master/android/settings.gradle
    <br> I have the above suspicion because both links seem to result in the same end point <- NO! 

TODO

- assemble magic links for download
- During a get file, scan current directory and check for conflict names before write (possibly over writing the downloaded file)
- user functionality idea, before jumping directly into each folder ask to explore.to sum up, fzf over the folder names before fzf over the folder's contents. 
envisioning potential usage<br>
<pre>$  getgit [-r] [link_to_file|link_to_dir]</pre>
Examples:
<pre>$ getgit link_to_file</pre>
...downloads file in current directory (checks not to overwrite first)

<pre>$ getgit link_to_dir</pre>
...downloads all files in dir and JUST THE NAMES of possible other direcries 

<pre>$ getgit -r link_to_dir</pre>
... recursively download all things


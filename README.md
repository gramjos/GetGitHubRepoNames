####	Print to console's standard output the names of the public repositories associated with the given user name

<p align="center">
  <img src="https://media.giphy.com/media/HpzuGSi9W97idMmzIv/giphy.gif" alt="demo_gif"/>
</p>


Github uses the URL below for user repository page
<p align="center">
  https://github.com/gramjos?tab=repositories </p>
The only unique part of the URL is the username gramjos

ASIDE: Using the profile page has the same data and its URL is
	"https://github.com/gramjos"

In the code snippet below. I ask the user for their username

```shell
	echo "Enter your GitHub URL: "
	read GitHubUserName;
```

I assemble the URL with string concatenation 

```shell
	fpart="https://github.com/"
	spart="?tab=repositories"
	repoURL=$fpart$GitHubUserName$spart;
```

I use curl to retrieve the HTML from 
	"https://github.com/gramjos?tab=repositories"

The curl command prints download status information to standard error. This 
	status information will be redirected to /dev/null. This is done to keep
	the console clear of any data that is NOT the repositories names

```shell
	curl $repoURL 2> /dev/null
```

Parsing HTML with awk
	Awk will process the retrieved HTML line by line. 
	The line of interest is below

```shell        
	<a href="/gramjos/DePaul_SE350" itemprop="name codeRepository" >
```

	The attribute itemprop and its value "name codeRepository" indicate this 
		line of HTML (specifically the anchor tag) will hold the repository
		name

```shell  
	$0 ~ /itemprop=\"name codeRepository\"/ 
```

	Anytime the entire line ($0) matches the pattern print certain parts

	$0 ~ /pattern/ {print ...}

	In this case the pattern is itemprop="name codeRepository"
	When this pattern is implemented the double will be escaped.

	By default awk will separate each line into various field demarcated 
		by spaces. Will override this default behavior by specifying the
		field separator flag -F. The argument to this a regular expression.
		

```shell	
	-F"/|\""  
```

	The argument is in double quotes. The expression matches either a forward
		slash or a double quote (escaped character required). 

Understanding field separator
  given the awk command

```shell
	curl $repoURL 2> /dev/null | \
	  awk -F"/|\"" 	\
	  '$0 ~ /itemprop=\"name codeRepository\" >/ {print "1: "$1"  2: "$2" 3: "$3" 4: "$4}'
```

	Results
		Enter your GitHub User Name: 
		gramjos
		1:         <a href=  2:  3: gramjos 4: vim
		1:         <a href=  2:  3: gramjos 4: create-data-science-workflow
		1:         <a href=  2:  3: gramjos 4: vopen
		1:         <a href=  2:  3: gramjos 4: DePaul_SE350
		1:         <a href=  2:  3: gramjos 4: GetGitHubRepoNames
		1:         <a href=  2:  3: gramjos 4: hello-word

Notice how the second field is blank

```shell     
	<a href="/gramjos/DePaul_SE350" itemprop="name codeRepository" >	
```

There is no contents in between the two possible field separators



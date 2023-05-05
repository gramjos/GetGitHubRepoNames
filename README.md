<h3 align="center">
	Display GitHub Repositories of given user name
</h3>
<h5 align="center">
The GIFF below shows the following commands:<br>

```shell
cat repoNames.sh
```

    <ul>
	 <li>display the script being ran</li>
    </ul>

```shell
    source repoNames.sh && listRepos
```

    <ul>
	 <li>display the script being ran</li>
    </ul>

</h5>

<p align="center">
  <img 
    src="https://media.giphy.com/media/QS6nYlQUgstr48Jyb7/giphy.gif"
	alt="demo_gif"
  />
  
</p>


Github uses the URL below for user repository pages's
<p align="center">https://github.com/gramjos?tab=repositories </p>
The only unique part of the URL is the username gramjos

ASIDE: Using the profile page has the same data and its URL is
<p align="center">
	"https://github.com/gramjos"
</p>

In the code snippet below. I ask the user for their username

```shell
	echo "Enter your GitHub URL: "
	read GitHubUserName;
```

I assemble the URL with string concatenation 

```shell
	domain="https://github.com/"
	query="?tab=repositories"
	repoURL=$domain$GitHubUserName$query;
```

I use curl to retrieve the HTML from 
	"https://github.com/gramjos?tab=repositories"

The curl command prints download status information to standard error. This 
	status information will be redirected to /dev/null. This is done to keep
	the console clear of any data that is NOT the repositories names

```shell
	curl $repoURL 2> /dev/null
```

Parsing HTML with awk<br>
	&nbsp;&nbsp;Awk will process the retrieved HTML line by line.<br> 
	&nbsp;&nbsp;The line of interest is below

```HTML        
	<a href="/gramjos/DePaul_SE350" itemprop="name codeRepository" >
```

<p>The attribute itemprop and its value "name codeRepository" indicate this 
		line of HTML (specifically the anchor tag) will hold the repository
		name</p>

```shell  
	$0 ~ /itemprop=\"name codeRepository\"/ 
```

<p>Anytime the entire line ($0) matches the pattern print certain parts</p>

	$0 ~ /pattern/ {print ...}

<p>In this case, the pattern is itemprop="name codeRepository" <br>
	When this pattern is implemented the double quotes are escaped.</p>

<p>By default awk will separate each line into various field demarcated 
		by spaces. Will override this default behavior by specifying the
		field separator flag -F. The argument to this a regular expression.</p>
		

```shell	
	-F"/|\""  
```

<p>The argument is in double quotes. The expression matches either a forward
		slash or a double quote (escaped character required). </p>

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


## List Repos
# TODO multiple command line args. As many as possible. 
if certain parts are unknowable then match around it


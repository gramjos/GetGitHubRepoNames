# HTML from https://github.com/gramjos?tab=repositories
#
#         <a href="/gramjos/DePaul_SE350" itemprop="name codeRepository" >

# meta data about from the curl process is diverted using 2> /dev/null
# pipe the html to awk
# fields flag on for "/ ... "    ellipsis repersents content between field 
# 	boundaries
# $0 match against the whole line the regex between foward slashes
# 		itemprop=\"name codeRepository\" >
# print the second field of those matched
listRepos() {
	echo "Enter your GitHub URL: "
	read GitHubUserName;
	fpart="https://github.com/"
	spart="?tab=repositories"
	repoURL=$fpart$GitHubUserName$spart;

	curl $repoURL 2> /dev/null | \
		awk -F"/|\"" '$0 ~ /itemprop=\"name codeRepository\" >/ {print $4}'
}


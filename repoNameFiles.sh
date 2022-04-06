listRepoFiles() {
	echo "Enter your GitHub User Name: "
	read GitHubUserName;
	fpart="https://github.com/"
	spart="?tab=repositories"
	repoURL=$fpart$GitHubUserName$spart;

	curl $repoURL 2> /dev/null | \
		awk -F"/|\"" '$0 ~ /itemprop=\"name codeRepository\" >/ {print $4}'\
		> tmp.text
# use -v flag in awk command for spcified repo name 
}


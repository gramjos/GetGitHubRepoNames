#!/usr/bin/env zsh

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
listRepoFiles "$@";

curl -s $repoURL |\
	awk -F">|<"	'$0 ~ /class="js-navigation-open Link--primary"/ {print $5}';

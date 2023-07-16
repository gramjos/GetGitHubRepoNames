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
	awk -F">|<"	'$0 ~ /class="js-navigation-open Link--primary"/ {print $5}';
usage_statement(){
	e="░░░░  this program needs two args   ░░░░"; 
	use="🌀 listRepoFiles [GitHub Username] [Repository Name]";
	printf $e $use;
}

listRepoFiles() {
	arg_ct=($#);
	arg_lst=$@;
	if [[ arg_ct -ne 2 ]]; then 
		usage_statement;
		exit 1;
	fi

}



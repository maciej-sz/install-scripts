#!/usr/bin/env bash

# Defaults:
WD="~/temp/install/mono"
PREFIX="/usr/local"
BRANCH="mono-3.2.1-branch"

function usage() {
	cat <<EOF
This script installs Mono from github.

Usage: $0 options

OPTIONS:
 -h		Show this help message.
 -g		Install GtkSharp.
 -w		Path to temp directory to download mono. Default is "$WD".
 -t		Target directory to install. Default is "$TG".
 -b		Branch name in the git repository. Default is "$BRANCH".
EOF
}


while getopts "hgw:t:b:" opt
do
	case ${opt} in
		h)
			usage;
			exit 1;
			;;
		g)
			
		w)
			WD=$OPTARG;
			;;
		t)
			TG=$OPTARG;
			;;
		b)
			BRANCH=$OPTARG;
			;;
		\?)
			echo -e "Invalid option: -$OPTARG\nSee $0 -h for help."
			exit 1;
			;;
	esac
done

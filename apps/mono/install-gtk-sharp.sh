#!/usr/bin/env bash

# Defaults:
WD="~/temp/install/mono"
PREFIX="/usr/local"
BRANCH="gtk-sharp-2-12-branch"

function usage() {
	cat <<EOF
This script installs GtkSharp from github.

Usage: $0 options

OPTIONS:
 -h		Show this help message.
 -w		Path to temp directory to download. Default is "$WD".
 -p		Target directory to install. Default is "$PREFIX".
 -b		Branch name in the git repository. Default is "$BRANCH".
EOF
}


while getopts "hw:p:b:" opt
do
	case $opt in
		h)
			usage;
			exit 1;
			;;
		w)
			WD=$OPTARG;
			;;
		p)
			PREFIX=$OPTARG;
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

source is-lib.sh

clear
captureSudo
#aptInstall "realpath" "realpath
gitGet "https://github.com/mono/gtk-sharp.git" ${BRANCH} ${WD} CCWD
#$CCWD=$(gitGet "https://github.com/mono/gtk-sharp.git" $BRANCH $WD)
echo ${CCWD}
ccInstall ${CCWD} "--prefix=$PREFIX"

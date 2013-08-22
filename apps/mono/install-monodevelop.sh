#!/usr/bin/env bash

source is-lib.sh

# Defaults:
WD="~/temp/install/mono";
PREFIX="/usr/local";
BRANCH="monodevelop-4.1.9-branch"

function usage() {
    cat <<EOF
This script installs MonoDefelop from GitHub.

Usage: $0 options

OPTIONS:
 -h     Show this help message.
 -w     Path to temp directory to download MonoDevelop. Default is "$WD".
 -p     Prefix directory to install. Default is "$PREFIX".
 -b     Branch name in the git repository. Default is "$BRANCH".
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

captureSudo
aptInstall "git" "git"
aptInstall "gnome-sharp2"
gitGet "https://github.com/mono/gtk-sharp.git" "gtk-sharp-2-12-branch" $WD
ccInst "$WD/gtk-sharp"
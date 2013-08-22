#!/usr/bin/env bash

# Safely executes a commend in first parameter (as string), and exits the
# script with message if the command fails.
# param 1: the code to execute
# param 2 [optional]: the message to display
function run {
    if [ $# -lt 1 ] ; then
        echo -e "run() function failure: provide code to run"
    fi
    #eval "$1 2>/dev/null"
	source "$1"
    if [ $? -ne 0 ] ; then
        if [ $# -gt 1 ] ; then
            echo -e $2
        else
			echo
            echo "Failure running: $1"
			echo "Exiting."
        fi
        exit 1
    fi
}

# Creates a directory.
# param 1: the path to directory to be created
# param 2 [optional]: 0 or 1 determines whether or not to pwd to the new
# directory
function createDir {
    if [ $# -lt 1 ] ; then
        echo -e "Usage error: createDir requires dir path"
        exit 1
    fi
    if [ ! -d $1 ] ; then
        run "mkdir -p $1" "Cannot create directory: $1"
    fi

    if [[ $# -gt 1 && $2 -eq 1 ]] ; then
        run "cd $1"
    fi
}

# Extracts a base name from file path.
#
# Example:
#  base=$(fileBaseName "/path/to/foo.bar.txt")
#  echo $base
#
# Outputs:
#  foo.bar
#
# param 1: the file path
function fileBaseName {
    local filename=$(basename "$1")
    local basename="${filename%.*}"
    echo "$basename"
}

# Check whether the specified directory is writable, and optionally exits if
# it is not.
function checkDirWritable {
	aptInstall "realpath" "realpath"
    if [ ! -w $(realpath $1) ] ; then
        echo -e "Directory is not writable or does not exist: $1"
        if [[ $# -gt 1 && $2 -eq 1 ]] ; then
            exit 0
        fi
    fi
}

# Extracts a file extension from file path.
#
# Example:
#  ext=$(fileExt "/path/to/foo.bar.txt")
#  echo $ext
#
# Outputs:
#  txt
#
# param 1: the file path
function fileExt {
    local filename=$(basename "$1")
    local ext="${filename##*.}"
    echo "$ext"
}

# Checks if script is run with root privileges and throws a message if
# it does not.
function checkRunWithRoot {
    if [ "$(id -u)" != 0 ] ; then
        echo "This script must be run with root privileges"
        exit 1
    fi
}

# Captures sudo privileges for later use in the script
function captureSudo {
    sudo echo >/dev/null
}

# Checks if a command exists (available to execute).
#
# Example:
#  if [ $(commandExists "vim") != "1" ] ; then
#      sudo apt-get install vim
#  fi
#
# Output:
#  # this code will install vim if it is not present
#
# param 1: the command name
function commandExists {
    if [ ! `command -v $1` ] ; then
        echo 0
    else
        echo 1
    fi
}

# Installs an package via Debian/Ubuntu apt

# param 1: the package name
#
# param 2 [optional]: string containing name of command name to check
#   before install. If that command exists and is executable, then the
#   installation won't get run.
#
# param 3 [optional]: optional file path to check. If it does exist 
#   then the installation won't be run.
#
function aptInstall {
    local run=1

	# if provided command to check:
    if [[ $# -gt 1 && $2 != 0 ]] ; then
        if [ $(commandExists $2) != 0 ] ; then
            run=0
        fi
    fi

	# if provided file to check:
	if [[ $# -gt 2 ]] ; then
		if [ -f $3 ] ; then
			run=0
		fi
	fi

    if [ ${run} -eq 1 ] ; then
        run "sudo apt-get -y install $1"
    fi
}



# Checks out a git repository
# param 1: repo url
# param 2: branch name
# param 3: working directory path
function gitGet {
    if [ $# -lt 3 ] ; then
        echo -e "Usage error: gitGet requires 3 parameters:"
        echo -e " 1) repo url"
        echo -e " 2) branch name"
        echo -e " 3) working directory path"
        exit 1
    fi

    local base=$(fileBaseName $1)
    local wd="$3/$base"

    if [ ! -d "$wd" ] ; then
        echo ${wd}
        createDir $3 1
        run "git clone $1"
    fi
    checkDirWritable ${wd} 1

    run "cd $wd"
    run "git checkout $2"
    run "git pull --rebase"
	pwd
	
	if [ ! -z $4 ] ; then
		local res=$4
		eval ${res}="'$wd'"
	fi
}

# Configures, compiles and installs the source
# param 1: working directory
# param 2 [optional]: optional parameters to include in the configure script
function ccInstall {
    run "cd $1"
    local to_run="./configure"
    if [ $# -gt 1 ] ; then
        # include optional parameters
        to_run="$to_run $2"
    fi
	run ${to_run}
    run "make"
    run "sudo make install"
}

#!/bin/bash

readonly JUNK_DIR=~/.junk
usage() {
cat<< USAGE
Usage: junk.sh [-hlp] [list of files]
    -h: Display help.
    -l: List junked files.
    -p: Purge all files.
    [list of files] with no other arguments to junk those files.
USAGE
}

#checks if there are no arguments
if [ $# -eq 0 ]; then
	usage
	exit 0
fi

flag=0
#parse the input command
while getopts "hlp" option; do
	case $option in
		h) help=true
			((flag=flag+1))
			;;
		l) list=true
			((flag=flag+1))
			;; #List junked files
		p) purge=true
			((flag=flag+1))
			;; #Purge all files
		\?) >&2 echo "Error: Unknown option -$OPTARG."
			usage
			exit 1
			;;
	esac
done

#Checks if more than one flag is specified
if [ $flag -ge 2 ] ; then
	>&2 echo "Error: Too many options enabled."
	usage
	exit 1
fi

#get argument after hlp
shift $((OPTIND -1))

#check last situation when files are specified along with flag
if [ "$list"=true ] || ["$purge"=true ] ; then
	if [ $# -ne 0 ] ; then 
		>&2 echo "Error: Too many options enabled."
		usage
		exit 1		
	fi
fi

#checks if directory exists or create one
if [ ! -d "$JUNK_DIR" ]; then
        mkdir "$JUNK_DIR"
fi

#performs -l function
if [ "$list" = true ] ; then
	ls -lAF "$JUNK_DIR"
	exit 0
fi

#performs -p function
if [ "$purge" = true ] ; then
	rm -rf "$JUNK_DIR"
	exit 0
fi

if [ $# -gt 0 ]; then
	for file in "$@"; do
		if [ -e "$file" ]; then
			mv "$file" "$JUNK_DIR"
		else
			err "Warning: '$file' not found"
		fi
	done
fi


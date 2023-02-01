#!/bin/bash

readonly JUNK_DIR = ~/.junk

cat<< USAGE
Usage: junk.sh [-hlp] [list of files]
    -h: Display help.
    -l: List junked files.
    -p: Purge all files.
    [list of files] with no other arguments to junk those files.
USAGE

#check directory exists or create one
if [ ! -d "$JUNK_DIR"]; then
	mkdir "$JUNK_DIR"
fi

#parse the input command
while getopts "hlp" option; do
	case $option in
		h) USAGE
		exit 0;;
		l) list = true;; #List junked files
		p) purge = true;; #Purge all files
		\?) err "Error: Unknown option -$OPTARG."
			USAGE
			exit 1;;
	esac
done

#Checks if more than one flag is specified
if [ "$list" = true ] && [ "$purge" = true]; then
	err "Too many options enabled."
fi

#get argument after hlp
shift $((OPTIND -1))

#check last situation when files are specified along with flag
if [ "$list" = true ] || ["$purge" = true ]; then
	if [ $# -ne 0]; 
		err "Too many options enabled."
	fi
fi

#performs -l function
if [ "$list" = true]; then
	ls -lAF "$JUNK_DIR"
	exit 0
fi

#performs -p function
if [ "$purge" = true]; then
	rm -rf "$JUNK_DIR"
	exit 0
fi

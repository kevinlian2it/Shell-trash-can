#!/bin/bash

#check directory exists or create one
if [ ! -d ~/.junk]; then
	mkdir ~/.junk
fi

#parse the input command
while getopts "hlp" option; do
	case $option in
		h) U
		exit 0;;
		l) list = true;; #List junked files
		p) purge = true;; #Purge all files
		\?) err "Error: Unknown option -$OPTARG."
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
	ls -lAF ~/.junk
	exit 0
fi

#performs -p function
if [ "$purge" = true]; then
	rm -rf ~/.junk/*
	exit 0
fi

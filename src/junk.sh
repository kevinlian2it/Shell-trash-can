#!/bin/bash
##### exit code
readonly JUNK_DIR=~/.junk
usage() {
cat<< USAGE
Usage: $(basename "$0") [-hlp] [list of files]
    -h: Display help.
    -l: List junked files.
    -p: Purge all files.
    [list of files] with no other arguments to junk those files.
USAGE
}

#checks if there are no arguments
if [ $# -eq 0 ]; then
	usage
	exit 1
fi

flag=0
h_flag=0
l_flag=0
p_flag=0
#parse the input command
while getopts ":hlp" opt; do
	case $opt in
		h) help=true
			((h_flag=1))
			;;
		l) list=true
			((l_flag=1))
			;; #List junked files
		p) purge=true
			((p_flag=1))
			;; #Purge all files
		\?) >&2 echo "Error: Unknown option '-${OPTARG}'."
			usage
			exit 1
			;;
	esac
done

flag=$(($h_flag+$l_flag+$p_flag))

#Checks if more than one flag is specified
if [ $flag -ge 2 ] ; then
	>&2 echo "Error: Too many options enabled."
	usage
	exit 1
fi

#get argument after hlp
shift $((OPTIND -1))

#check last situation when files are specified along with flag
if [ $flag -gt 0 ] ; then
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

#performs -h function
if [ "$help" = true ] ; then
        usage
        exit 0
fi

#performs -l function
if [ "$list" = true ] ; then
	ls -lAF "$JUNK_DIR"
	exit 0
fi

#performs -p function
if [ "$purge" = true ] ; then
	rm -rf "$JUNK_DIR"/{*,.*}
	exit 0
fi

if [ $# -gt 0 ]; then
	for file in "$@"; do
		if [ -e "$file" ] ; then
			mv "$file" "$JUNK_DIR"
		else
			>&2 echo "Warning: '$file' not found"
		fi
	done
	exit 0
fi

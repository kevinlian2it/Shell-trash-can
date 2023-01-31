#!/bin/bash
####################
# two functions needed to reuse
Usage (){
    echo "Usage: junk.sh [-hlp] [list of files]"
    echo "  -h: Display help."
    echo "  -l: List junked files."
    echo "  -p: Purge all files."
    echo "  [list of files] with no other arguments to junk those files."
    exit 1
}

err (){
    echo "Error: $1"
    Usage
    exit 1
}

#check directory exists or create one
if [ ! -d ~/.junk ]; then
    mkdir ~/.junk
fi 

# Check if there is no arguments
if [ $# -eq 0 ]; then
    Usage
    exit 0
fi

# read the input command
while getopts "hlp" option; do
    case $option in
      h) Usage # Display Help
         exit 0;;
      l) list=true;; # List junked files.     
      p) purge=true;; # Purge all files.
     \?) err "Error: Unknown option -$OPTARG."
    esac
done

# Check if more than one flag is specified
if [ "$list" = true ] && [ "$purge" = true ]; then      
    err "Too many options enabled."
fi

# to get the arguement after hlp
shift $((OPTIND -1))

# Check the last situation, when files are specified along with the flag
if [ "$list" = true ] || [ "$purge" = true ]; then ## when l or p exists
    if [ $# -ne 0 ]; then # when the files exist
        err "Too many options enabled."
    fi
fi

# List junked files if -l flag is specified
if [ "$list" = true ]; then
    ls -lAF ~/.junk
    exit 0 # success
fi

# Purge all files in the junk directory if -p flag is specified
if [ "$purge" = true ]; then
    rm -rf ~/.junk/* # delete everything in the root directory
    exit 0 # success
fi


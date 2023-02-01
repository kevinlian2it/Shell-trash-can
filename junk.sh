#!/bin/bash
####################
# two functions needed to repeat below

Usage (){
    echo "Usage: junk.sh [-hlp] [list of files]"
    echo "  -h: Display help."
    echo "  -l: List junked files."
    echo "  -p: Purge all files."
    echo "  [list of files] with no other arguments to junk those files."
    # no needs to exit
}

err (){
    echo "Error: $1"
    Usage
    exit 1 # exit 1 means error
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
      l) list=true;; # List junked files     
      p) purge=true;; # Purge all files
     \?) err "Error: Unknown option -$OPTARG."
    esac
done

# Check if more than one flag is specified
if [ "$list" = true ] && [ "$purge" = true ]; then      
    err "Too many options enabled."
fi

# to get the arguement after hlp, moving to the next command
shift $((OPTIND -1))

# Check the last situation, when files are specified along with the flag
if [ "$list" = true ] || [ "$purge" = true ]; then ## when l or p exists
    if [ $# -ne 0 ]; then # while the file exists as well
        err "Too many options enabled."
    fi
fi

# List junked files if -l flag is specified
if [ "$list" = true ]; then
    ls -lAF ~/.junk # Combine these arguments for a long format list of all files with types
    exit 0 # success
fi

# Purge all files in the junk directory if -p flag is specified
if [ "$purge" = true ]; then
    rm -rf ~/.junk/* # delete everything in the root directory
    exit 0 # success
fi


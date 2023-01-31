#!/bin/bash
####################
function Usage (){
    echo "Usage: junk.sh [-hlp] [list of files]"
    echo "  -h: Display help."
    echo "  -l: List junked files."
    echo "  -p: Purge all files."
    echo "  [list of files] with no other arguments to junk those files."
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

while getopts "hlp" option; do
    case $option in
      h) Usage # Display Help
         exit 0;;
      l) list=true # List junked files.
         exit 0;;      
      p) purge=true # Purge all files.
         exit 0;;      
     \?) echo "Error: Unknown option -$OPTARG."
         Usage
         exit 1;;
    esac
done

# Check if more than one flag is specified
if [ "$list" = true ] && [ "$purge" = true ]; then      
    echo "Too many options enabled."
    Usage
    exit 1;;
fi

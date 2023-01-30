#!/bin/bash

function Usage (){
    echo "Usage: junk.sh [-hlp] [list of files]"
    echo "  -h: Display help."
    echo "  -l: List junked files."
    echo "  -p: Purge all files."
    echo "  [list of files] with no other arguments to junk those files."
    exit 1
}

function checkFileExists (){
    if find ~/.junkdir -name $1 -print -quit | grep -q '^'; then #if the file can be found then continue
        return 0
    else
        echo "Warning: '$1' not found"
        exit 1
    fi

}

function checkDirExists (){
    if [ ! -e ~/.junkdir ]; then  #If the chunkdir is not there then run create directory
        echo 'Junk Directory has not been found'
        createDirectory
    fi
}

function createDirectory (){
    mkdir ~/.junkdir #makes the junk dir then checks to ensure it was made
    echo 'Junk Directory has been created'
    checkDirExists
}

function listFiles (){
    checkDirExists
    checkDirEmpty
    fileNames=$( ls -A ~/.junkdir )#Seperately get the file name,size and type and store
    fileSizes=$(find ~/.junkdir/* -printf '%s\n';)
    fileTypes=$(find ~/.junkdir/* | xargs file |  awk '{print $3}')
    printf "%-20s %-20s %-20s\n" "File Name" "Size" "Type"      # printf for formatating and paste and awk for joining then formating
    printf "%-20s %-20s %-20s\n" "-----" "-----" "-----"
    Output=$(paste <(echo "$fileNames") <(echo "$fileSizes") <(echo "$fileTypes") | awk '{ printf "%-20s %-20s %-20s\n" , $1, $2, $3 }' )
    echo "$Output"
}

while getopts "hlp:" option; do
   case $option in
      h) Help;; # Display Help
      l) List;; # List junked files.
      p) Purge;; # Purge all files.
      ?) echo "Error: Unknown option -$OPTARG."
         Usage;;
      :) echo "Error: Too many options enabled."
         Usage;;

  esac
done

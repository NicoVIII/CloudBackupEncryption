#!/bin/bash

#TODO: Documentation
#TODO: Add informative output messages

#Use flag -u to unzip archives automatically

#Check flags
unzip=0
while getopts ":u" opt; do
  case $opt in
    u)
      unzip=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

mkdir "../decrypted"

find . -depth ! -path . -type d | while read i
do
    mkdir "../decrypted/$i"
done

find . -depth -type f -iname "*.gpg" | while read j
do
	zip=${j::-4}
	dir=$(dirname "$zip")
    gpg --output "../decrypted/$zip" --decrypt "$j"
	if [ $unzip = 1 ] && [[ $zip == *.zip ]]; then
		unzip "../decrypted/$zip" -d "../decrypted/$dir"
	fi
done
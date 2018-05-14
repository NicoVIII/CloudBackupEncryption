#!/bin/bash

#TODO: Documentation

progname="CloudBackupEncryption"
libname="Decryption Library"
version="v0.1.1"

#Check flags
unzip=0
while getopts ":u:v" opt; do
    case $opt in
        u)
            unzip=1;;
        v)
            echo $progname "-" $libname
            echo $version
            exit 0;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1;;
    esac
done

echo $progname $version "-" $libname

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
		unzip "../decrypted/$zip" -d "../decrypted/$dir" > /dev/null
        rm "../decrypted/$zip"
	fi
done
echo "Finished decrypting!"
exit 0

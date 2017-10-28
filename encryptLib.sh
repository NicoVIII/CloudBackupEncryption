#!/bin/bash

#TODO: Documentation

#Parameters
email=$1

mkdir "../backup"
mkdir "../tmp"

# Files in home directory
find . -maxdepth 1 -type f | while read i
do
	echo "file: $i"
	gpg --output "../backup/$i.gpg" --encrypt --recipient $email "$i"
done

# Directories in home directory
find . -maxdepth 1 ! -path . -type d | while read i
do
	echo "outer: $i"
	mkdir "../backup/$i"
	mkdir "../tmp/$i"

	# Files in Directory
	find $i -maxdepth 1 -type f | while read j
	do
		echo "file: $j"
		gpg --output "../backup/$j.gpg" --encrypt --recipient $email "$j"
	done

	# Directories in Directory (zip first)
	find $i -maxdepth 1 ! -path $i -type d | while read j
	do
		echo "inner: $j"
		cd "$i"
		folder=$(basename "$j")
		zip -r "../../tmp/$j.zip" "./$folder"
		cd ..
		gpg --output "../backup/$j.zip.gpg" --encrypt --recipient $email "../tmp/$j.zip"
	done
done

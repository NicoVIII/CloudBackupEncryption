#!/bin/bash
DIR=$(dirname $0);DECRYPT=pgpbackup-decrypt;command -v pgpbackup-decrypt > /dev/null || DECRYPT="$DIR/$DECRYPT";

exec $DECRYPT -u -o "$DIR/../decrypted" -- "$DIR"

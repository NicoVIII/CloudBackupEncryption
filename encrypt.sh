#!/bin/bash
DIR=$(dirname $0);ENCRYPT=pgpbackup-encrypt;command -v pgpbackup-encrypt > /dev/null || ENCRYPT="$DIR/$ENCRYPT";

exec $ENCRYPT -r <email_to_encrypt_for> -- "$DIR"

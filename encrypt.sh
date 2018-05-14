#!/bin/bash
ENCRYPT=pgpbackup-encrypt;command -v pgpbackup-encrypt > /dev/null || ENCRYPT=./$ENCRYPT;

exec $ENCRYPT <email_to_encrypt_for>

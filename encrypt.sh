#!/bin/bash
ENCRYPT=pgpbackup-encrypt;command -v pgpbackup-encrypt || ENCRYPT=./$ENCRYPT;

exec $ENCRYPT <email_to_encrypt_for>

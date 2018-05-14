#!/bin/bash
DECRYPT=pgpbackup-decrypt;command -v pgpbackup-decrypt > /dev/null || DECRYPT=./$DECRYPT;

exec $DECRYPT -u

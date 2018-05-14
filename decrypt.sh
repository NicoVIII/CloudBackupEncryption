#!/bin/bash
DECRYPT=pgpbackup-decrypt;command -v pgpbackup-decrypt || DECRYPT=./$DECRYPT;

exec $DECRYPT -u

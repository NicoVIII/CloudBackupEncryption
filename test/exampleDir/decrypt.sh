#!/bin/bash
$(dirname $0)/pgpbackup-decrypt -Vu -o "$(dirname $0)/../decrypted" -- $(dirname $0)

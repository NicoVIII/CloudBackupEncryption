#!/bin/bash
$(dirname $0)/pgpbackup-encrypt --no-name-hashing -r nico@nicoviii.net -o "$(dirname $0)/../backup" -- $(dirname $0)

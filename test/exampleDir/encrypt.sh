#!/bin/bash
$(dirname $0)/pgpbackup-encrypt -d 0 -r nico@nicoviii.net -o "$(dirname $0)/../backup" -- $(dirname $0)

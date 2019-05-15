#!/bin/bash
readonly inFolder="${_arg_input#"/"}"
readonly outFolder="${_arg_output#"/"}"

# Prepare tmp folder
readonly rootFolder=$(dirname $outFolder)
if [ -d "$rootFolder/tmp" ]; then
    for i in {1..9}
    do
        if [ ! -d "$rootFolder/tmp$i" ]; then
            tmp="tmp$i"
            break
        fi
    done
else
    tmp="tmp"
fi
readonly tmpFolder="$rootFolder/$tmp"
mkdir "$tmpFolder"

# Create named pipe for file size counter
readonly encryptedBytesPipe="$tmpFolder/encryptedBytes"
echo 0 > "$encryptedBytesPipe"

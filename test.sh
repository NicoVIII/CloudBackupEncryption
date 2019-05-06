#!/bin/bash
echo "Start testing."

# Prepare tests
cp ./deploy/* ./testDir

(
    cd "./testDir"

    # Test 1: No params - Encrypt
    echo "Test: No params - Encrypt"
    ./pgpbackup-encrypt nico@nicoviii.net

    # TODO
)

# Delete test scripts
rm "./testDir/pgpbackup-*"

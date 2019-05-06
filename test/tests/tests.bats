#!/usr/bin/env bats
setup() {
    cp -R "deploy/." "./test/exampleDir/"
    cd "./test/exampleDir"
}

teardown() {
    # Delete test scripts and created folders
    rm "./pgpbackup-encrypt" "./pgpbackup-decrypt" || :
    rm -r "../backup"

    cd "../.."
}

@test "Basic invoke without depth and without namehashing" {
    run ./pgpbackup-encrypt --no-name-hashing -- nico@nicoviii.net
    [ "$status" -eq 0 ]

    # Check structure of encrypted files
    [ -f "../backup/decrypt.sh" ]
    [ -f "../backup/encrypt.sh.gpg" ]
    [ -f "../backup/pgpbackup-decrypt" ]
    [ -f "../backup/pgpbackup-encrypt.gpg" ]
    [ -f "../backup/file1.file.gpg" ]
    [ -f "../backup/folder1/file2.file.gpg" ]
    [ -f "../backup/folder1/folder2/file3.file.gpg" ]
    [ -f "../backup/folder1/folder3/file4.file.gpg" ]
}

#!/usr/bin/env bats
email="nico@nicoviii.net"

cp -R "deploy/." "./test/exampleDir/"

setup() {
    cd "./test/exampleDir"
}

teardown() {
    # Delete created folders
    rm -r "../backup" 2> /dev/null || :
    rm -r "../decrypted" 2> /dev/null || :

    cd "../.."
}

@test "Basic invoke without depth and without namehashing" {
    run "./pgpbackup-encrypt" --no-name-hashing -- "$email"
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

    # TODO: Try to workaround issue with #22
    cd "../backup"
    run "./pgpbackup-decrypt" -u
    [ "$status" -eq 0 ]
    cd "../exampleDir"

    # Check structure of encrypted files
    [ -f "../decrypted/decrypt.sh" ]
    [ -f "../decrypted/encrypt.sh" ]
    [ -f "../decrypted/pgpbackup-decrypt" ]
    [ -f "../decrypted/pgpbackup-encrypt" ]
    [ -f "../decrypted/file1.file" ]
    [ -f "../decrypted/folder1/file2.file" ]
    [ -f "../decrypted/folder1/folder2/file3.file" ]
    [ -f "../decrypted/folder1/folder3/file4.file" ]
}

@test "Test quiet parameter" {
    run ."/pgpbackup-encrypt" -q --no-name-hashing -- "$email"
    [ "$status" -eq 0 ]
    [ "$output" = "" ]

    # TODO: Try to workaround issue with #22
    cd "../backup"
    run "../backup/pgpbackup-decrypt" -qu
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
    cd "../exampleDir"
}

@test "Test quiet parameter in combination with verbose parameter" {
    run "./pgpbackup-encrypt" -qV --no-name-hashing -- "$email"
    [ "$status" -eq 0 ]
    [ "$output" = "" ]

    # TODO: Try to workaround issue with #22
    cd "../backup"
    run "../backup/pgpbackup-decrypt" -quV
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
    cd "../exampleDir"
}

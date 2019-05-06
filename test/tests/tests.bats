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
    run "./pgpbackup-encrypt" --no-name-hashing -r "$email"
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

    run "./pgpbackup-decrypt" -u -- "../backup"
    [ "$status" -eq 0 ]

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

@test "Basic invoke without depth but with namehashing" {
    run "./pgpbackup-encrypt" -r "$email"
    [ "$status" -eq 0 ]

    # Check for some key files
    [ -f "../backup/decrypt.sh" ]
    [ -f "../backup/pgpbackup-decrypt" ]
    [ -f "../backup/overview.txt.gpg" ]
    [ -f "../backup/foldernames.txt.gpg" ]

    run "./pgpbackup-decrypt" -u -- "../backup"
    [ "$status" -eq 0 ]

    # Check structure of encrypted files
    [ -f "../decrypted/decrypt.sh" ]
    [ -f "../decrypted/encrypt.sh" ]
    [ -f "../decrypted/pgpbackup-decrypt" ]
    [ -f "../decrypted/pgpbackup-encrypt" ]
    [ -f "../decrypted/overview.txt" ]
    [ -f "../decrypted/file1.file" ]
    [ -f "../decrypted/folder1/file2.file" ]
    [ -f "../decrypted/folder1/folder2/file3.file" ]
    [ -f "../decrypted/folder1/folder3/file4.file" ]
    [ ! -f "../decrypted/foldernames.txt" ]
}

@test "Test quiet parameter" {
    run ."/pgpbackup-encrypt" -q --no-name-hashing -r "$email"
    [ "$status" -eq 0 ]
    [ "$output" = "" ]

    run "./pgpbackup-decrypt" -qu -- "../backup"
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}

@test "Test quiet parameter in combination with verbose parameter" {
    run "./pgpbackup-encrypt" -qV --no-name-hashing -r "$email"
    [ "$status" -eq 0 ]
    [ "$output" = "" ]

    run "./pgpbackup-decrypt" -quV -- "../backup"
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}

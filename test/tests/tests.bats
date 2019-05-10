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

@test "Invoke with quiet" {
    run ."/pgpbackup-encrypt" -q -r "$email"
    if [ ! "$status" -eq 0 ]; then echo "$output"; fi
    [ "$status" -eq 0 ]
    [ "$output" = "" ]

    run "./pgpbackup-decrypt" -qu -- "../backup"
    if [ ! "$status" -eq 0 ]; then echo "$output"; fi
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}

@test "Invoke with quiet and verbose" {
    run "./pgpbackup-encrypt" -qV -r "$email"
    if [ ! "$status" -eq 0 ]; then echo "$output"; fi
    [ "$status" -eq 0 ]
    [ "$output" = "" ]

    run "./pgpbackup-decrypt" -quV -- "../backup"
    if [ ! "$status" -eq 0 ]; then echo "$output"; fi
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}

@test "Basic invoke" {
    run "./pgpbackup-encrypt" -r "$email"
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

    # Check content of encrypted files
    [ "$(< ../backup/file1.file.gpg)" != "file-one-content" ]
    [ "$(< ../backup/folder1/file2.file.gpg)" != "file-two-content" ]
    [ "$(< ../backup/folder1/folder2/file3.file.gpg)" != "file-three-content" ]
    [ "$(< ../backup/folder1/folder3/file4.file.gpg)" != "file-four-content" ]

    run "./pgpbackup-decrypt" -u -- "../backup"
    [ "$status" -eq 0 ]

    # Check structure of decrypted files
    [ -f "../decrypted/decrypt.sh" ]
    [ -f "../decrypted/encrypt.sh" ]
    [ -f "../decrypted/pgpbackup-decrypt" ]
    [ -f "../decrypted/pgpbackup-encrypt" ]
    [ -f "../decrypted/file1.file" ]
    [ -f "../decrypted/folder1/file2.file" ]
    [ -f "../decrypted/folder1/folder2/file3.file" ]
    [ -f "../decrypted/folder1/folder3/file4.file" ]

    # Check content of decrypted files
    [ "$(< ../decrypted/file1.file)" = "file-one-content" ]
    [ "$(< ../decrypted/folder1/file2.file)" = "file-two-content" ]
    [ "$(< ../decrypted/folder1/folder2/file3.file)" = "file-three-content" ]
    [ "$(< ../decrypted/folder1/folder3/file4.file)" = "file-four-content" ]
}

@test "Invoke with namehashing" {
    run "./pgpbackup-encrypt" -n -r "$email"
    [ "$status" -eq 0 ]

    # Check for some key files
    [ -f "../backup/decrypt.sh" ]
    [ -f "../backup/pgpbackup-decrypt" ]
    [ -f "../backup/overview.txt.gpg" ]
    [ -f "../backup/foldernames.txt.gpg" ]

    run "./pgpbackup-decrypt" -u -- "../backup"
    [ "$status" -eq 0 ]

    # Check structure of decrypted files
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

    # Check content of decrypted files
    [ "$(< ../decrypted/file1.file)" = "file-one-content" ]
    [ "$(< ../decrypted/folder1/file2.file)" = "file-two-content" ]
    [ "$(< ../decrypted/folder1/folder2/file3.file)" = "file-three-content" ]
    [ "$(< ../decrypted/folder1/folder3/file4.file)" = "file-four-content" ]
}

@test "Invoke with depth 0" {
    run "./pgpbackup-encrypt" -d 0 -r "$email"
    if [ ! "$status" -eq 0 ]; then echo "$output"; fi
    [ "$status" -eq 0 ]

    # Check structure of encrypted files
    [ -f "../backup/decrypt.sh" ]
    [ -f "../backup/pgpbackup-decrypt" ]
    [ -f "../backup/backup.zip.gpg" ]

    run "./pgpbackup-decrypt" -u -- "../backup"
    [ "$status" -eq 0 ]

    # Check structure of decrypted files
    [ -f "../decrypted/decrypt.sh" ]
    [ -f "../decrypted/encrypt.sh" ]
    [ -f "../decrypted/pgpbackup-decrypt" ]
    [ -f "../decrypted/pgpbackup-encrypt" ]
    [ -f "../decrypted/file1.file" ]
    [ -f "../decrypted/folder1/file2.file" ]
    [ -f "../decrypted/folder1/folder2/file3.file" ]
    [ -f "../decrypted/folder1/folder3/file4.file" ]

    # Check content of decrypted files
    [ "$(< ../decrypted/file1.file)" = "file-one-content" ]
    [ "$(< ../decrypted/folder1/file2.file)" = "file-two-content" ]
    [ "$(< ../decrypted/folder1/folder2/file3.file)" = "file-three-content" ]
    [ "$(< ../decrypted/folder1/folder3/file4.file)" = "file-four-content" ]
}

@test "Invoke with depth 1" {
    run "./pgpbackup-encrypt" -V -d 1 -r "$email"
    if [ ! "$status" -eq 0 ]; then echo "$output"; fi
    [ "$status" -eq 0 ]
    echo "$output"

    # Check structure of encrypted files
    [ -f "../backup/decrypt.sh" ]
    [ -f "../backup/pgpbackup-decrypt" ]
    [ -f "../backup/encrypt.sh.gpg" ]
    [ -f "../backup/pgpbackup-encrypt.gpg" ]
    [ -f "../backup/file1.file.gpg" ]
    [ -f "../backup/folder1.zip.gpg" ]

    run "./pgpbackup-decrypt" -u -- "../backup"
    [ "$status" -eq 0 ]

    # Check structure of decrypted files
    [ -f "../decrypted/decrypt.sh" ]
    [ -f "../decrypted/encrypt.sh" ]
    [ -f "../decrypted/pgpbackup-decrypt" ]
    [ -f "../decrypted/pgpbackup-encrypt" ]
    [ -f "../decrypted/file1.file" ]
    [ -f "../decrypted/folder1/file2.file" ]
    [ -f "../decrypted/folder1/folder2/file3.file" ]
    [ -f "../decrypted/folder1/folder3/file4.file" ]

    # Check content of decrypted files
    [ "$(< ../decrypted/file1.file)" = "file-one-content" ]
    [ "$(< ../decrypted/folder1/file2.file)" = "file-two-content" ]
    [ "$(< ../decrypted/folder1/folder2/file3.file)" = "file-three-content" ]
    [ "$(< ../decrypted/folder1/folder3/file4.file)" = "file-four-content" ]
}

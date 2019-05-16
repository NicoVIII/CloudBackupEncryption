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

function log_on_failure() {
  echo Failed with status "$status" and output:
  echo "$output"
}

# ! Can not be used for now, because error will not be specific enough
function checkDecrypted {
    local withHidden=$1

    # Check structure of decrypted files
    [ -f "../decrypted/decrypt.sh" ]
    [ -f "../decrypted/encrypt.sh" ]
    [ -f "../decrypted/pgpbackup-decrypt" ]
    [ -f "../decrypted/pgpbackup-encrypt" ]
    [ -f "../decrypted/file1.file" ]
    [ -f "../decrypted/folder1/file2.file" ]
    [ -f "../decrypted/folder1/folder2/file3.file" ]
    [ -f "../decrypted/folder1/folder with spaces/file4.file" ]
    if [ "$withHidden" = "on" ]; then
        [ -f "../decrypted/.hidden.file" ]
        [ -f "../decrypted/folder1/.hidden2.file" ]
        [ -d "../decrypted/.hidden-folder" ]
        [ -f "../decrypted/.hidden-folder/file5.file" ]
        [ -f "../decrypted/.hidden-folder/.hidden3.file" ]
    else
        [ ! -f "../decrypted/.hidden.file" ]
        [ ! -f "../decrypted/folder1/.hidden2.file" ]
        [ ! -d "../decrypted/.hidden-folder" ]
        [ ! -f "../decrypted/.hidden-folder/file5.file" ]
        [ ! -f "../decrypted/.hidden-folder/.hidden3.file" ]
    fi

    # Check content of decrypted files
    [ "$(< ../decrypted/file1.file)" = "file-one-content" ]
    [ "$(< ../decrypted/folder1/file2.file)" = "file-two-content" ]
    [ "$(< ../decrypted/folder1/folder2/file3.file)" = "file-three-content" ]
    [ "$(< "../decrypted/folder1/folder with spaces/file4.file")" = "file-four-content" ]
    if [ "$withHidden" = "on" ]; then
        [ "$(< ../decrypted/.hidden.file)" = "hidden-file-content" ]
        [ "$(< ../decrypted/folder1/.hidden2.file)" = "hidden-file-two-content" ]
        [ "$(< ../decrypted/.hidden-folder/file5.file)" = "file-five-content" ]
        [ "$(< ../decrypted/.hidden-folder/.hidden3.file)" = "hidden-file-three-content" ]
    fi
}

@test "Invoke with quiet" {
    run ."/pgpbackup-encrypt" -q -r "$email"

    log_on_failure

    [ "$status" -eq 0 ]
    [ "$output" = "" ]

    run "./pgpbackup-decrypt" -qu -- "../backup"

    log_on_failure

    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}

@test "Invoke with quiet and verbose" {
    run "./pgpbackup-encrypt" -qV -r "$email"

    log_on_failure

    [ "$status" -eq 0 ]
    [ "$output" = "" ]

    run "./pgpbackup-decrypt" -quV -- "../backup"

    log_on_failure

    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}

@test "Basic invoke" {
    run "./pgpbackup-encrypt" -V -r "$email"

    log_on_failure

    [ "$status" -eq 0 ]

    # Check structure of encrypted files
    [ ! -f "../backup/.hidden.file.gpg" ]
    [ ! -f "../backup/folder1/.hidden2.file.gpg" ]
    [ -f "../backup/decrypt.sh" ]
    [ -f "../backup/encrypt.sh.gpg" ]
    [ -f "../backup/pgpbackup-decrypt" ]
    [ -f "../backup/pgpbackup-encrypt.gpg" ]
    [ -f "../backup/file1.file.gpg" ]
    [ -f "../backup/folder1/file2.file.gpg" ]
    [ -f "../backup/folder1/folder2/file3.file.gpg" ]
    [ -f "../backup/folder1/folder with spaces/file4.file.gpg" ]

    # Check content of encrypted files
    [ "$(< ../backup/file1.file.gpg 2>/dev/null)" != "file-one-content" ]
    [ "$(< ../backup/folder1/file2.file.gpg 2>/dev/null)" != "file-two-content" ]
    [ "$(< ../backup/folder1/folder2/file3.file.gpg 2>/dev/null)" != "file-three-content" ]
    [ "$(< "../backup/folder1/folder with spaces/file4.file.gpg" 2>/dev/null)" != "file-four-content" ]

    run "./pgpbackup-decrypt" -Vu -- "../backup"

    log_on_failure

    [ "$status" -eq 0 ]

    # Check structure of decrypted files
    [ -f "../decrypted/decrypt.sh" ]
    [ -f "../decrypted/encrypt.sh" ]
    [ -f "../decrypted/pgpbackup-decrypt" ]
    [ -f "../decrypted/pgpbackup-encrypt" ]
    [ -f "../decrypted/file1.file" ]
    [ -f "../decrypted/file with spaces.file" ]
    [ -f "../decrypted/folder1/file2.file" ]
    [ -f "../decrypted/folder1/folder2/file3.file" ]
    [ -f "../decrypted/folder1/folder with spaces/file4.file" ]
    [ ! -f "../decrypted/.hidden.file" ]
    [ ! -f "../decrypted/folder1/.hidden2.file" ]
    [ ! -d "../decrypted/.hidden-folder" ]
    [ ! -f "../decrypted/.hidden-folder/file5.file" ]
    [ ! -f "../decrypted/.hidden-folder/.hidden3.file" ]

    # Check content of decrypted files
    [ "$(< "../decrypted/file with spaces.file")" = "file-with-spaces-content" ]
    [ "$(< ../decrypted/file1.file)" = "file-one-content" ]
    [ "$(< ../decrypted/folder1/file2.file)" = "file-two-content" ]
    [ "$(< ../decrypted/folder1/folder2/file3.file)" = "file-three-content" ]
    [ "$(< "../decrypted/folder1/folder with spaces/file4.file")" = "file-four-content" ]
}

@test "Invoke with namehashing" {
    run "./pgpbackup-encrypt" -Vn -r "$email"

    log_on_failure

    [ "$status" -eq 0 ]

    # Check for some key files
    [ -f "../backup/decrypt.sh" ]
    [ -f "../backup/pgpbackup-decrypt" ]
    [ -f "../backup/overview.txt.gpg" ]
    [ -f "../backup/foldernames.txt.gpg" ]

    run "./pgpbackup-decrypt" -Vu -- "../backup"

    log_on_failure

    [ "$status" -eq 0 ]

    # Check structure of decrypted files
    [ ! -f "../decrypted/.hidden.file" ]
    [ ! -f "../decrypted/folder1/.hidden2.file" ]
    [ ! -d "../decrypted/.hidden-folder" ]
    [ ! -f "../decrypted/.hidden-folder/file5.file" ]
    [ ! -f "../decrypted/.hidden-folder/.hidden3.file" ]
    [ -f "../decrypted/decrypt.sh" ]
    [ -f "../decrypted/encrypt.sh" ]
    [ -f "../decrypted/pgpbackup-decrypt" ]
    [ -f "../decrypted/pgpbackup-encrypt" ]
    [ -f "../decrypted/overview.txt" ]
    [ -f "../decrypted/file1.file" ]
    [ -f "../decrypted/file with spaces.file" ]
    [ -f "../decrypted/folder1/file2.file" ]
    [ -f "../decrypted/folder1/folder2/file3.file" ]
    [ -f "../decrypted/folder1/folder with spaces/file4.file" ]
    [ ! -f "../decrypted/foldernames.txt" ]

    # Check content of decrypted files
    [ "$(< "../decrypted/file with spaces.file")" = "file-with-spaces-content" ]
    [ "$(< ../decrypted/file1.file)" = "file-one-content" ]
    [ "$(< ../decrypted/folder1/file2.file)" = "file-two-content" ]
    [ "$(< ../decrypted/folder1/folder2/file3.file)" = "file-three-content" ]
    [ "$(< "../decrypted/folder1/folder with spaces/file4.file")" = "file-four-content" ]
}

@test "Invoke with depth 0" {
    run "./pgpbackup-encrypt" -V -d 0 -r "$email"

    log_on_failure

    [ "$status" -eq 0 ]

    # Check structure of encrypted files
    [ ! -f "../backup/.hidden.file.gpg" ]
    [ ! -f "../backup/folder1/.hidden2.file.gpg" ]
    [ -f "../backup/decrypt.sh" ]
    [ -f "../backup/pgpbackup-decrypt" ]
    [ -f "../backup/backup.zip.gpg" ]

    run "./pgpbackup-decrypt" -Vu -- "../backup"

    log_on_failure

    [ "$status" -eq 0 ]

    # Check structure of decrypted files
    [ -f "../decrypted/decrypt.sh" ]
    [ -f "../decrypted/encrypt.sh" ]
    [ -f "../decrypted/pgpbackup-decrypt" ]
    [ -f "../decrypted/pgpbackup-encrypt" ]
    [ -f "../decrypted/file1.file" ]
    [ -f "../decrypted/file with spaces.file" ]
    [ -f "../decrypted/folder1/file2.file" ]
    [ -f "../decrypted/folder1/folder2/file3.file" ]
    [ -f "../decrypted/folder1/folder with spaces/file4.file" ]
    [ ! -f "../decrypted/.hidden.file" ]
    [ ! -f "../decrypted/folder1/.hidden2.file" ]
    [ ! -d "../decrypted/.hidden-folder" ]
    [ ! -f "../decrypted/.hidden-folder/file5.file" ]
    [ ! -f "../decrypted/.hidden-folder/.hidden3.file" ]

    # Check content of decrypted files
    [ "$(< "../decrypted/file with spaces.file")" = "file-with-spaces-content" ]
    [ "$(< ../decrypted/file1.file)" = "file-one-content" ]
    [ "$(< ../decrypted/folder1/file2.file)" = "file-two-content" ]
    [ "$(< ../decrypted/folder1/folder2/file3.file)" = "file-three-content" ]
    [ "$(< "../decrypted/folder1/folder with spaces/file4.file")" = "file-four-content" ]
}

@test "Invoke with depth 1" {
    run "./pgpbackup-encrypt" -V -d 1 -r "$email"

    log_on_failure

    [ "$status" -eq 0 ]

    # Check structure of encrypted files
    [ ! -f "../backup/.hidden.file.gpg" ]
    [ ! -f "../backup/folder1/.hidden2.file.gpg" ]
    [ -f "../backup/decrypt.sh" ]
    [ -f "../backup/pgpbackup-decrypt" ]
    [ -f "../backup/encrypt.sh.gpg" ]
    [ -f "../backup/pgpbackup-encrypt.gpg" ]
    [ -f "../backup/file1.file.gpg" ]
    [ -f "../backup/folder1.zip.gpg" ]

    run "./pgpbackup-decrypt" -Vu -- "../backup"

    log_on_failure

    [ "$status" -eq 0 ]

    # Check structure of decrypted files
    [ -f "../decrypted/decrypt.sh" ]
    [ -f "../decrypted/encrypt.sh" ]
    [ -f "../decrypted/pgpbackup-decrypt" ]
    [ -f "../decrypted/pgpbackup-encrypt" ]
    [ -f "../decrypted/file1.file" ]
    [ -f "../decrypted/file with spaces.file" ]
    [ -f "../decrypted/folder1/file2.file" ]
    [ -f "../decrypted/folder1/folder2/file3.file" ]
    [ -f "../decrypted/folder1/folder with spaces/file4.file" ]
    [ ! -f "../decrypted/.hidden.file" ]
    [ ! -f "../decrypted/folder1/.hidden2.file" ]
    [ ! -d "../decrypted/.hidden-folder" ]
    [ ! -f "../decrypted/.hidden-folder/file5.file" ]
    [ ! -f "../decrypted/.hidden-folder/.hidden3.file" ]

    # Check content of decrypted files
    [ "$(< "../decrypted/file with spaces.file")" = "file-with-spaces-content" ]
    [ "$(< ../decrypted/file1.file)" = "file-one-content" ]
    [ "$(< ../decrypted/folder1/file2.file)" = "file-two-content" ]
    [ "$(< ../decrypted/folder1/folder2/file3.file)" = "file-three-content" ]
    [ "$(< "../decrypted/folder1/folder with spaces/file4.file")" = "file-four-content" ]
}

@test "Invoke with depth 2" {
    run "./pgpbackup-encrypt" -V -d 2 -r "$email"

    log_on_failure

    [ "$status" -eq 0 ]

    # Check structure of encrypted files
    [ ! -f "../backup/.hidden.file.gpg" ]
    [ ! -f "../backup/folder1/.hidden2.file.gpg" ]
    [ -f "../backup/decrypt.sh" ]
    [ -f "../backup/pgpbackup-decrypt" ]
    [ -f "../backup/encrypt.sh.gpg" ]
    [ -f "../backup/pgpbackup-encrypt.gpg" ]
    [ -f "../backup/file1.file.gpg" ]
    [ -f "../backup/folder1/file2.file.gpg" ]
    [ -f "../backup/folder1/folder2.zip.gpg" ]
    [ -f "../backup/folder1/folder with spaces.zip.gpg" ]

    run "./pgpbackup-decrypt" -Vu -- "../backup"

    log_on_failure

    [ "$status" -eq 0 ]

    # Check structure of decrypted files
    [ -f "../decrypted/decrypt.sh" ]
    [ -f "../decrypted/encrypt.sh" ]
    [ -f "../decrypted/pgpbackup-decrypt" ]
    [ -f "../decrypted/pgpbackup-encrypt" ]
    [ -f "../decrypted/file1.file" ]
    [ -f "../decrypted/file with spaces.file" ]
    [ -f "../decrypted/folder1/file2.file" ]
    [ -f "../decrypted/folder1/folder2/file3.file" ]
    [ -f "../decrypted/folder1/folder with spaces/file4.file" ]
    [ ! -f "../decrypted/.hidden.file" ]
    [ ! -f "../decrypted/folder1/.hidden2.file" ]
    [ ! -d "../decrypted/.hidden-folder" ]
    [ ! -f "../decrypted/.hidden-folder/file5.file" ]
    [ ! -f "../decrypted/.hidden-folder/.hidden3.file" ]

    # Check content of decrypted files
    [ "$(< "../decrypted/file with spaces.file")" = "file-with-spaces-content" ]
    [ "$(< ../decrypted/file1.file)" = "file-one-content" ]
    [ "$(< ../decrypted/folder1/file2.file)" = "file-two-content" ]
    [ "$(< ../decrypted/folder1/folder2/file3.file)" = "file-three-content" ]
    [ "$(< "../decrypted/folder1/folder with spaces/file4.file")" = "file-four-content" ]
}

@test "Invoke with depth 1 and namehashing" {
    run "./pgpbackup-encrypt" -nV -d 1 -r "$email"

    log_on_failure

    [ "$status" -eq 0 ]

    # Check for some key files
    [ -f "../backup/decrypt.sh" ]
    [ -f "../backup/pgpbackup-decrypt" ]
    [ -f "../backup/overview.txt.gpg" ]

    run "./pgpbackup-decrypt" -Vu -- "../backup"

    log_on_failure

    [ "$status" -eq 0 ]

    # Check structure of decrypted files
    [ ! -f "../decrypted/.hidden.file" ]
    [ ! -f "../decrypted/folder1/.hidden2.file" ]
    [ -f "../decrypted/decrypt.sh" ]
    [ -f "../decrypted/encrypt.sh" ]
    [ -f "../decrypted/pgpbackup-decrypt" ]
    [ -f "../decrypted/pgpbackup-encrypt" ]
    [ -f "../decrypted/file1.file" ]
    [ -f "../decrypted/file with spaces.file" ]
    [ -f "../decrypted/folder1/file2.file" ]
    [ -f "../decrypted/folder1/folder2/file3.file" ]
    [ -f "../decrypted/folder1/folder with spaces/file4.file" ]

    # Check content of decrypted files
    [ "$(< "../decrypted/file with spaces.file")" = "file-with-spaces-content" ]
    [ "$(< ../decrypted/file1.file)" = "file-one-content" ]
    [ "$(< ../decrypted/folder1/file2.file)" = "file-two-content" ]
    [ "$(< ../decrypted/folder1/folder2/file3.file)" = "file-three-content" ]
    [ "$(< "../decrypted/folder1/folder with spaces/file4.file")" = "file-four-content" ]
}

@test "Invoke with depth 2 and namehashing" {
    run "./pgpbackup-encrypt" -nV -d 2 -r "$email"

    log_on_failure

    [ "$status" -eq 0 ]

    # Check for some key files
    [ -f "../backup/decrypt.sh" ]
    [ -f "../backup/pgpbackup-decrypt" ]
    [ -f "../backup/overview.txt.gpg" ]
    [ -f "../backup/foldernames.txt.gpg" ]

    run "./pgpbackup-decrypt" -Vu -- "../backup"

    log_on_failure

    [ "$status" -eq 0 ]

    # Check structure of decrypted files
    [ ! -f "../decrypted/.hidden.file" ]
    [ ! -f "../decrypted/folder1/.hidden2.file" ]
    [ -f "../decrypted/decrypt.sh" ]
    [ -f "../decrypted/encrypt.sh" ]
    [ -f "../decrypted/pgpbackup-decrypt" ]
    [ -f "../decrypted/pgpbackup-encrypt" ]
    [ -f "../decrypted/file1.file" ]
    [ -f "../decrypted/file with spaces.file" ]
    [ -f "../decrypted/folder1/file2.file" ]
    [ -f "../decrypted/folder1/folder2/file3.file" ]
    [ -f "../decrypted/folder1/folder with spaces/file4.file" ]

    # Check content of decrypted files
    [ "$(< "../decrypted/file with spaces.file")" = "file-with-spaces-content" ]
    [ "$(< ../decrypted/file1.file)" = "file-one-content" ]
    [ "$(< ../decrypted/folder1/file2.file)" = "file-two-content" ]
    [ "$(< ../decrypted/folder1/folder2/file3.file)" = "file-three-content" ]
    [ "$(< "../decrypted/folder1/folder with spaces/file4.file")" = "file-four-content" ]
}

@test "Invoke with all" {
    run "./pgpbackup-encrypt" -aV -r "$email"

    log_on_failure

    [ "$status" -eq 0 ]

    # Check structure of encrypted files
    [ -f "../backup/.hidden.file.gpg" ]
    [ -f "../backup/folder1/.hidden2.file.gpg" ]
    [ -f "../backup/decrypt.sh" ]
    [ -f "../backup/encrypt.sh.gpg" ]
    [ -f "../backup/pgpbackup-decrypt" ]
    [ -f "../backup/pgpbackup-encrypt.gpg" ]
    [ -f "../backup/file1.file.gpg" ]
    [ -f "../backup/folder1/file2.file.gpg" ]
    [ -f "../backup/folder1/folder2/file3.file.gpg" ]
    [ -f "../backup/folder1/folder with spaces/file4.file.gpg" ]

    run "./pgpbackup-decrypt" -Vu -- "../backup"

    log_on_failure

    [ "$status" -eq 0 ]

    # Check structure of decrypted files
    [ -f "../decrypted/decrypt.sh" ]
    [ -f "../decrypted/encrypt.sh" ]
    [ -f "../decrypted/pgpbackup-decrypt" ]
    [ -f "../decrypted/pgpbackup-encrypt" ]
    [ -f "../decrypted/file1.file" ]
    [ -f "../decrypted/file with spaces.file" ]
    [ -f "../decrypted/folder1/file2.file" ]
    [ -f "../decrypted/folder1/folder2/file3.file" ]
    [ -f "../decrypted/folder1/folder with spaces/file4.file" ]
    [ -f "../decrypted/.hidden.file" ]
    [ -f "../decrypted/folder1/.hidden2.file" ]
    [ -d "../decrypted/.hidden-folder" ]
    [ -f "../decrypted/.hidden-folder/file5.file" ]
    [ -f "../decrypted/.hidden-folder/.hidden3.file" ]

    # Check content of decrypted files
    [ "$(< "../decrypted/file with spaces.file")" = "file-with-spaces-content" ]
    [ "$(< ../decrypted/file1.file)" = "file-one-content" ]
    [ "$(< ../decrypted/folder1/file2.file)" = "file-two-content" ]
    [ "$(< ../decrypted/folder1/folder2/file3.file)" = "file-three-content" ]
    [ "$(< "../decrypted/folder1/folder with spaces/file4.file")" = "file-four-content" ]
    [ "$(< ../decrypted/.hidden.file)" = "hidden-file-content" ]
    [ "$(< ../decrypted/folder1/.hidden2.file)" = "hidden-file-two-content" ]
    [ "$(< ../decrypted/.hidden-folder/file5.file)" = "file-five-content" ]
    [ "$(< ../decrypted/.hidden-folder/.hidden3.file)" = "hidden-file-three-content" ]
}

@test "Invoke with all and depth 1 and name hashing" {
    run "./pgpbackup-encrypt" -anV -d 1 -r "$email"

    log_on_failure

    [ "$status" -eq 0 ]

    # Check structure of encrypted files
    [ -f "../backup/decrypt.sh" ]
    [ -f "../backup/pgpbackup-decrypt" ]

    run "./pgpbackup-decrypt" -Vu -- "../backup"

    log_on_failure

    [ "$status" -eq 0 ]

    # Check structure of decrypted files
    [ -f "../decrypted/decrypt.sh" ]
    [ -f "../decrypted/encrypt.sh" ]
    [ -f "../decrypted/pgpbackup-decrypt" ]
    [ -f "../decrypted/pgpbackup-encrypt" ]
    [ -f "../decrypted/file1.file" ]
    [ -f "../decrypted/file with spaces.file" ]
    [ -f "../decrypted/folder1/file2.file" ]
    [ -f "../decrypted/folder1/folder2/file3.file" ]
    [ -f "../decrypted/folder1/folder with spaces/file4.file" ]
    [ -f "../decrypted/.hidden.file" ]
    [ -f "../decrypted/folder1/.hidden2.file" ]
    [ -d "../decrypted/.hidden-folder" ]
    [ -f "../decrypted/.hidden-folder/file5.file" ]
    [ -f "../decrypted/.hidden-folder/.hidden3.file" ]

    # Check content of decrypted files
    [ "$(< "../decrypted/file with spaces.file")" = "file-with-spaces-content" ]
    [ "$(< ../decrypted/file1.file)" = "file-one-content" ]
    [ "$(< ../decrypted/folder1/file2.file)" = "file-two-content" ]
    [ "$(< ../decrypted/folder1/folder2/file3.file)" = "file-three-content" ]
    [ "$(< "../decrypted/folder1/folder with spaces/file4.file")" = "file-four-content" ]
    [ "$(< ../decrypted/.hidden.file)" = "hidden-file-content" ]
    [ "$(< ../decrypted/folder1/.hidden2.file)" = "hidden-file-two-content" ]
    [ "$(< ../decrypted/.hidden-folder/file5.file)" = "file-five-content" ]
    [ "$(< ../decrypted/.hidden-folder/.hidden3.file)" = "hidden-file-three-content" ]
}

# PGP-Backup

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![GitHub Release](https://img.shields.io/github/release/NicoVIII/PGP-Backup.svg)](https://github.com/NicoVIII/PGP-Backup/releases/latest)
[![Github Pre-Release](https://img.shields.io/github/release/NicoVIII/PGP-Backup/all.svg?label=prerelease)](https://github.com/NicoVIII/PGP-Backup/releases)
[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/NicoVIII/CloudBackupEncryption/master/LICENSE.txt)

This project intends to provide tools for users to easily encrypt a filestructure with PGP. It should be possible to store backups in a cloud without giving the cloud provider too much information about stored data.
Because this project consists out of batch scripts, it will only work on Linux systems. It may work on macOS, but that is not tested.

## Dependencies

For this scripts to run approprietly you need a working gpg setup. The scripts call gpg to decrypt or encrypt, so you need an existing keypair for given email address.
The commands zip and unzip are called as well, so these must be accessible too. For most linux distributions this is given per default, as far as I know.

## Usage

### Encryption

1.  Put both `.sh` and `pgpbackup-encrypt` and `pgpbackup-decrypt` files into the folder which contents you want to encrypt.
2.  Open `encrypt.sh` and replace `<email_to_encrypt_for>` with the email, which is part of your pgp key. If you want to encrypt the backup for multiple keys, just add the other email addresses after the first one.
3.  Configure encryption in `encrypt.sh`. Look up the options at [Options / encrypt](#encrypt)
4.  You should configure decryption in `decrypt.sh` right now, if you want to configure it for every backup. The files will be copied into the backup, to decrypt the backup later. Look up the options at [Options / decrypt](#decrypt)
5.  Execute `encrypt.sh`. It will start the encryption. The backup will be placed inside a `backup` folder next to the folder with the files.

### Decryption

1.  The files `decrypt.sh` and `pgpbackup-decrypt` should not be encrypted. If both are available you should be able to decrypt the backup.
2.  Execute `decrypt.sh`.

## Options

These are the options and flags you can use with the files and insert into `encrypt.sh` and `decrypt.sh`.

### encrypt

`-a | --(no-)all` : include hidden files  
`-d | --depth <depth>` : depth of zipping of directories - depth 0 is the zipping of all directories in the folder of the script - Have a look at [Examples](#Examples)  
`-h | --help` : Prints help  
`-n | --(no-)name-hashing` : hash filenames (enabled by default)  
`--(no-)hash-names` : hash filenames (deprecated, use --name-hashing instead)  
`-v | --version` : Prints version  
`-V | --(no-)verbose` : Prints more information about what the script is doing

### decrypt

`-h | --help` : Prints help  
`-u | --(no-)unpack` : unpacks all decrypted archives  
`-v | --version` : Prints version  
`-V | --(no-)verbose` : Prints more information about what the script is doing

## Examples

### Example 1

Given following file structure:

    folder
    |  file1.file
    |
    |__folder1
       |  file2.file
       |
       |__folder2
       |  | file3.file
       |
       |__folder3
          | file4.file

#### No Depth

With the following line in `encrypt.sh`:

    exec $ENCRYPT example@example.com

The encrypted filestructure looks like this:

    folder
    |  file1.file.gpg
    |
    |__folder1
       |  file2.file.gpg
       |
       |__folder2
       |  | file3.file.gpg
       |
       |__folder3
          | file4.file.gpg

#### Depth: 0

With the following line in `encrypt.sh`:

    exec $ENCRYPT -d 0 example@example.com

The encrypted filestructure looks like this:

    backup.zip.gpg

#### Depth: 1

With the following line in `encrypt.sh`:

    exec $ENCRYPT -d 1 example@example.com

The encrypted filestructure looks like this:

    folder
    |  file1.file.gpg
    |  folder1.zip.gpg

#### Depth: 2

With the following line in `encrypt.sh`:

    exec $ENCRYPT -d 2 example@example.com

The encrypted filestructure looks like this:

    folder
    |  file1.file.gpg
    |
    |__folder1
       |  file2.file.gpg
       |  folder2.zip.gpg
       |  folder3.zip.gpg

## Development

[![pipeline status](https://gitlab.com/NicoVIII/PGP-Backup/badges/master/pipeline.svg)](https://gitlab.com/NicoVIII/PGP-Backup/commits/master)

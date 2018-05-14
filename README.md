# CloudBackupEncryption
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![GitHub release](https://img.shields.io/github/release/NicoVIII/CloudBackupEncryption.svg)]()
[![Github Releases](https://img.shields.io/github/downloads/NicoVIII/CloudBackupEncryption/total.svg)]()
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/NicoVIII/CloudBackupEncryption/master/LICENSE.txt)

This project intends to provide tools for users to easily encrypt a filestructure with PGP. It should be possible to store backups in a cloud without giving the cloud provider too much information about stored data.
Because this project consists out of batch scripts, it will only work on Linux systems. It may work on macOS, but that is not tested.

## Dependencies
For this scripts to run approprietly you need a working gpg setup. The scripts call gpg to decrypt or encrypt, so you need an existing keypair for given email address.
The commands zip and unzip are called as well, so these must be accessible too. For most linux distributions this is given per default, as far as I know.

## Usage

### Encryption
1. Put all four `.sh` files into the folder which contents you want to encrypt.
2. Open `encrypt.sh` and replace `<email_to_encrypt_for>` with the email, which is part of your pgp key.
3. If you want to zip your directories, add `-d <depth>` with `<depth>` as the depth you wish for zipping directories. Depth 0 zipps all directories in the folder the script is in.
4. You should configure decrypt in `decrypt.sh` right now, if you want to configure it for every backup. The files will be copied into the backup, to decrypt the backup later. Look up the options at [Options / decryptLib](#decryptlib)
5. Make `encrypt.sh` and `encryptLib.sh` executable and execute `encrypt.sh`. It will start the encryption. All zipped folders are placed inside a `tmp` folder next to the folder with the files and the final backup inside a `backup` folder next to the folder with the files.

### Decryption
1. The files `decrypt.sh` and `decryptLib.sh` should not be encrypted. Make them executable in the backup you created.
2. Execute `decrypt.sh`.

## Options
These are the options and flags you can use with the files and insert into `encrypt.sh` and `decrypt.sh`.

### encryptLib
-d depth : depth of zipping of directories - depth 0 is the zipping of all directories in the folder of the script

### decryptLib
-u : unzippes all decrypted archives

## Examples

### Example 1

Given following file structure:
```
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
```

#### No Depth
With the following `encrypt.sh`:
```
encryptLib.sh example@example.com
```
The encrypted filestructure looks like this:
```
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
```

#### Depth: 0
With the following `encrypt.sh`:
```
encryptLib.sh -d 0 example@example.com
```
The encrypted filestructure looks like this:
```
folder
|  file1.file.gpg
|  folder1.zip.gpg
```

#### Depth: 1
With the following `encrypt.sh`:
```
encryptLib.sh -d 1 example@example.com
```
The encrypted filestructure looks like this:
```
folder
|  file1.file.gpg
|
|__folder1
   |  file2.file.gpg
   |  folder2.zip.gpg
```

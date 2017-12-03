# CloudBackupEncryption
[![GitHub release](https://img.shields.io/github/release/NicoVIII/CloudBackupEncryption.svg)]()
[![Github Releases](https://img.shields.io/github/downloads/NicoVIII/CloudBackupEncryption/total.svg)]()
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/NicoVIII/CloudBackupEncryption/master/LICENSE.txt)

This project intends to provide tools for users to easily encrypt a filestructure with PGP. It should be possible to store backups in a cloud without giving the cloud provider too much information about stored data.
Because this project contains out of batch scripts, it will only work on Linux systems. It may work on macOS, but that is not tested.

## Usage

### Encryption
1. Put all four `.sh` files into the folder which contents you want to encrypt.
2. Open `encrypt.sh` and replace `<email_to_encrypt_for>` with the email, which is part of your pgp key.
3. Also replace `<depth>` with the depth you wish for zipping directories. Depth 0 zipps all directories in the folder the script is in.
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

# CloudBackupEncryption
This project intends to provide tools for users to easily encrypt a filestructure with PGP. It should be possible to store backups in a cloud without giving the cloud provider too much information about stored data.

## Usage
1. Put all three `.sh` files into the folder which contents you want to encrypt.
2. Open `encrypt.sh` and replace `<email_to_encrypt_for>` with the email, which is part of your pgp key.
3. TODO: add info about depth parameter
4. Make `encrypt.sh` executable and execute it. It will start the encryption. All zipped folders are placed inside a `tmp` folder next to the folder with the files and the final backup inside a `backup` folder next to the folder with the files.

## Options
These are the options and flags you can use with the files and insert into `encrypt.sh` and `decrypt.sh`.

### encryptLib
(No options/flags in the current version)

### decryptLib
-u : unzippes all decrypted archives

#!/bin/bash
version=$1
type=$2

mkdir -p "tmp"
mkdir -p "deploy"

# Run Argbash
echo "Run argbash to build parameter support."
./argbash/bin/argbash pgpbackup-decrypt -o tmp/pgpbackup-decrypt
./argbash/bin/argbash pgpbackup-encrypt -o tmp/pgpbackup-encrypt

echo "Deploy scripts."
chmod +x ./decrypt.sh
chmod +x ./encrypt.sh
chmod +x tmp/pgpbackup-decrypt
chmod +x tmp/pgpbackup-encrypt

cp tmp/pgpbackup-decrypt deploy
cp tmp/pgpbackup-encrypt deploy

if [ "$version" != "" ]; then
    if [ "$type" == "tar" ]; then
        # Create .tar
        tar -cf "deploy/pgpbackup-v$version.tar" encrypt.sh decrypt.sh LICENSE README.md
        cd "tmp"
        tar -rf "../deploy/pgpbackup-v$version.tar" pgpbackup-decrypt pgpbackup-encrypt
        cd ".."

        xz -e9 --threads=0 -f "deploy/pgpbackup-v$version.tar"
    fi

    if [ "$type" == "tar-light" ]; then
        tar -cf "deploy/pgpbackup-v$version-light.tar" encrypt.sh decrypt.sh LICENSE README.md
        xz -e9 --threads=0 -f "deploy/pgpbackup-v$version-light.tar"
    fi
fi

# Clean up
rm -r "tmp"
echo "Finished."
exit 0

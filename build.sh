#!/bin/bash
version="v0.2.1"

type=$1

mkdir -p "tmp"
mkdir -p "deploy"

# Run Argbash
cp pgpbackup-decrypt tmp/pgpbackup-decrypt
cp pgpbackup-encrypt tmp/pgpbackup-encrypt

sed -i "s/__VERSION__/$version/g" tmp/pgpbackup-*

echo "Run argbash to build parameter support."
./argbash/bin/argbash tmp/pgpbackup-decrypt -o tmp/pgpbackup-decrypt
./argbash/bin/argbash tmp/pgpbackup-encrypt -o tmp/pgpbackup-encrypt

echo "Remove some unnecessary whitespaces."
sed -i "/^\s*$/d" tmp/pgpbackup-*
sed -i 's/^[ \t]*//;s/[ \t]*$//' tmp/pgpbackup-*

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
        tar -cf "deploy/pgpbackup-$version.tar" encrypt.sh decrypt.sh LICENSE README.md
        cd "tmp"
        tar -rf "../deploy/pgpbackup-$version.tar" pgpbackup-decrypt pgpbackup-encrypt
        cd ".."

        xz -e9 --threads=0 -f "deploy/pgpbackup-$version.tar"
    fi

    if [ "$type" == "tar-light" ]; then
        tar -cf "deploy/pgpbackup-$version-light.tar" encrypt.sh decrypt.sh LICENSE README.md
        xz -e9 --threads=0 -f "deploy/pgpbackup-$version-light.tar"
    fi
fi

# Clean up
rm -r "tmp"
echo "Finished."
exit 0

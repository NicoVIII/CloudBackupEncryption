#!/bin/bash
version="v1.0.0-alpha.1"

type=$1

mkdir -p "tmp"
mkdir -p "deploy"

# Run Argbash
cp pgpbackup-decrypt tmp/pgpbackup-decrypt
cp pgpbackup-encrypt tmp/pgpbackup-encrypt

sed -i "s/__VERSION__/$version/g" tmp/pgpbackup-*
sed -i "/#__INIT__/ {
    r init-code.sh
    d
}" tmp/pgpbackup-*
sed -i "/#__FUNCTIONS__/ {
    r helper-functions.sh
    d
}" tmp/pgpbackup-*
sed -i "s_#!/bin/bash__g" tmp/pgpbackup-*

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

# Test
if [ "$type" == "test" ]; then
    echo
    echo "Test, if build was successful."
    error=0
    if [ ! -f "./deploy/pgpbackup-encrypt" ]; then
        echo "Error: Did not find 'deploy/pgpbackup-encrypt!"
        error=1
    else
        echo "Found 'deploy/pgpbackup-encrypt'."
    fi
    if [ ! -f "./deploy/pgpbackup-decrypt" ]; then
        echo "Error: Did not find 'deploy/pgpbackup-decrypt!"
        error=1
    else
        echo "Found 'deploy/pgpbackup-decrypt'."
    fi
    exit $error
else
    exit 0
fi

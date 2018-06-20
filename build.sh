#!/bin/bash
version=$1
type=$2

mkdir -p "tmp"
mkdir -p "deploy"

# Run Argbash
./argbash/bin/argbash pgpbackup-decrypt -o tmp/pgpbackup-decrypt
./argbash/bin/argbash pgpbackup-encrypt -o tmp/pgpbackup-encrypt

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

    if [ "$type" == "deb" ]; then
        # Create .deb and light-.tar
        buildDir="deb"
        mkdir -p "$buildDir/pgpbackup-$version"
        cp tmp/pgpbackup-decrypt "$buildDir/pgpbackup-$version/pgpbackup-decrypt"
        cp tmp/pgpbackup-encrypt "$buildDir/pgpbackup-$version/pgpbackup-encrypt"
        cd "$buildDir/pgpbackup-$version"
        dh_make -s -e nicolinder@icloud.com --createorig
        cp "../../build/install" "debian/install"
        cp "../../build/control" "debian/control"
        cp "../../changelog.txt" "debian/changelog"
        rm debian/*.ex debian/*.EX
        debuild -us -uc
        cd ".."
        mv *.deb "../deploy"
        cd ".."
        rm -r $buildDir

        tar -cf "deploy/pgpbackup-v$version-light.tar" encrypt.sh decrypt.sh LICENSE README.md
        xz -e9 --threads=0 -f "deploy/pgpbackup-v$version-light.tar"
    fi
fi

# Clean up
rm -r "tmp"
exit 0

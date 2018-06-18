#!/bin/bash
version=$1

mkdir -p "tmp"
mkdir -p "deploy"

# Run Argbash
./argbash/bin/argbash pgpbackup-decrypt -o tmp/pgpbackup-decrypt
./argbash/bin/argbash pgpbackup-encrypt -o tmp/pgpbackup-encrypt

cp tmp/pgpbackup-decrypt deploy
cp tmp/pgpbackup-encrypt deploy

if [ "$version" != "" ]; then
    # Create .zip
    zip "deploy/pgpbackup-v$version.zip" encrypt.sh decrypt.sh LICENSE README.md
    cd "tmp"
    zip "../deploy/pgpbackup-v$version.zip" pgpbackup-decrypt pgpbackup-encrypt
    cd ".."

    # Create .deb and light-.zip
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

    zip "deploy/pgpbackup-v$version-light.zip" encrypt.sh decrypt.sh LICENSE.txt README.md
else
    echo "To build .deb package provide a version as first argument."
fi

# Clean up
rm -r "tmp"
exit 0

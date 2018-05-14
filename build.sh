#!/bin/bash
version=$1

# Create .zip
# TODO:

# Create .deb
if [ $1 != "" ]; then
    buildDir="tmp"
    mkdir $buildDir
    mkdir "$buildDir/pgpbackup-$version"
    cp pgpbackup-decrypt "$buildDir/pgpbackup-$version/pgpbackup-decrypt"
    cp pgpbackup-encrypt "$buildDir/pgpbackup-$version/pgpbackup-encrypt"
    cd "$buildDir/pgpbackup-$version"
    dh_make -s -e nicolinder@icloud.com --createorig
    cp "../../build/install" "debian/install"
    rm debian/*.ex debian/*.EX
    debuild
    cd ".."
    mv *.deb ".."
    cd ".."
    rm -r $buildDir
else
    echo "To build a .deb package, provide a version as first argument"
fi

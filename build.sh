#!/bin/bash
version=$1

if [ "$version" != "" ]; then
    mkdir "deploy"

    # Create .zip
    zip "deploy/pgpbackup-v$version.zip" pgpbackup-decrypt pgpbackup-encrypt encrypt.sh decrypt.sh LICENSE.txt README.md

    # Create .deb and light-.zip
    buildDir="tmp"
    mkdir $buildDir
    mkdir "$buildDir/pgpbackup-$version"
    cp pgpbackup-decrypt "$buildDir/pgpbackup-$version/pgpbackup-decrypt"
    cp pgpbackup-encrypt "$buildDir/pgpbackup-$version/pgpbackup-encrypt"
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
    echo "To build provide a version as first argument"
fi

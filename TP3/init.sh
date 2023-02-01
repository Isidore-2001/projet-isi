#! /bin/bash

function iniDirectories {
    mkdir -p USB1
    mkdir -p USB2
}

function initUSB1 {
    dd if=/dev/urandom bs=1 count=32 count=1 |  hexdump -ve '1/1 "%02x"' > USB1/key 
}

function initUSB2 {
    dd if=/dev/urandom bs=1 count=32 count=1 |  hexdump -ve '1/1 "%02x"' > USB2/key 
}

function cryptKey {
    gpg -c USB1/key
    gpg -c USB2/key
}

function init {
    initUSB1
    initUSB2
    cryptKey
}

function purgeKey {
    rm USB1/key
    rm USB2/key
}
iniDirectories
init
purgeKey
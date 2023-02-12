#! /bin/bash
source abstractInit.sh

function initUSB1() {
    dd if=/dev/urandom bs=32 count=1 |  hexdump -ve '1/1 "%02x"' > USB1/key 
}

function initUSB2() {
    dd if=/dev/urandom bs=32 count=1 |  hexdump -ve '1/1 "%02x"' > USB2/key 
}

function cryptKey {
	openssl enc -aes-256-cbc -in USB1/key -out USB1/key.crypt -A -pbkdf2
	openssl enc -aes-256-cbc -in USB2/key -out USB2/key.crypt -A -pbkdf2
}

function init {
    rm -rf DISK/*
    initUSB1
    initUSB2
    cryptKey 
	generateKey
	generateMasterKey
}

function purgeKey {
    rm -rf USB1/key
    rm -rf USB2/key
    rm -rf RAMDISK/*
}

initDirectories
init
purgeKey

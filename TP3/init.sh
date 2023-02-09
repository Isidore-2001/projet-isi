#! /bin/bash

function iniDirectories {
    mkdir -p USB1
    mkdir -p USB2
	mkdir -p DISK
	mkdir -p RAMDISK
}


function initUSB1 {
    dd if=/dev/urandom bs=1 count=32 count=1 |  hexdump -ve '1/1 "%02x"' > USB1/key 
}

function initUSB2 {
    dd if=/dev/urandom bs=1 count=32 count=1 |  hexdump -ve '1/1 "%02x"' > USB2/key 
}

function generateKey(){
	dd if=/dev/urandom bs=1 count=32 count=1 |  hexdump -ve '1/1 "%02x"' > RAMDISK/master_key2
}

function generateMasterKey {
	# generate a master key with combination of USB1 and USB2 key 
	openssl enc -aes-256-cbc -in RAMDISK/master_key2 -out RAMDISK/master_key_tmp.crypt -pbkdf2 -pass "pass:$(cat USB1/key)"
	openssl enc -aes-256-cbc -in RAMDISK/master_key_tmp.crypt -out DISK/master_key.crypt -pbkdf2 -pass "pass:$(cat USB2/key)"
}

function cryptKey {
    # gpg -c USB1/key
    # gpg -c USB2/key
	openssl enc -aes-256-cbc -in USB1/key -out USB1/key.crypt -A -pbkdf2
	openssl enc -aes-256-cbc -in USB2/key -out USB2/key.crypt -A -pbkdf2
}

function init {
    initUSB1
    initUSB2
    cryptKey 
	generateKey
	generateMasterKey
}

function purgeKey {
    rm USB1/key
    rm USB2/key
	rm RAMDISK/master_key
}
iniDirectories
init
#purgeKey

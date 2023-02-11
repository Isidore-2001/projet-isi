#! /bin/bash

function initDirectories() {
    mkdir -p USB1
    mkdir -p USB2
    mkdir -p USBREPRESENTATION/USB1
    mkdir -p USBREPRESENTATION/USB2
	mkdir -p DISK
	mkdir -p RAMDISK
}



function generateKey() {
	dd if=/dev/urandom bs=1 count=32 count=19 |  hexdump -ve '1/1 "%02x"' > RAMDISK/master_key
}

function generateMasterKey() {
	# generate a master key with combination of USB1 and USB2 keys
    echo "******************************Generating master key from USB1 and USB2******************************"
	openssl enc -aes-256-cbc -in RAMDISK/master_key -out RAMDISK/master_key_tmp.crypt -pbkdf2 -pass "pass:$(cat USB1/key)"
	openssl enc -aes-256-cbc -in RAMDISK/master_key_tmp.crypt -out DISK/master_key.crypt -pbkdf2 -pass "pass:$(cat USB2/key)"
}

#! /bin/bash
source abstractInit.sh

function initUSB1() {
    dd if=/dev/urandom bs=32 count=1 |  hexdump -ve '1/1 "%02x"' > USB1/key 
}

function initUSB2() {
    dd if=/dev/urandom bs=32 count=1 |  hexdump -ve '1/1 "%02x"' > USB2/key 
}

function cryptKey {
	echo "Saississez le mot de passe pour crypter la clé USB1"
	openssl enc -aes-256-cbc -in USB1/key -out USB1/key.crypt -A -pbkdf2
	if [[ $? -ne 0 ]]; then
		echo "****************************** USB1 key is wrong ******************************"
		exit 1
	else
		echo "****************************** USB1 key is correct ******************************"
	fi
	echo "Saississez le mot de passe pour crypter la clé USB2"

	openssl enc -aes-256-cbc -in USB2/key -out USB2/key.crypt -A -pbkdf2
	if [[ $? -ne 0 ]]; then
		echo "****************************** USB2 key is wrong ******************************"
		exit 1
	else
		echo "****************************** USB2 key is correct ******************************"
	fi
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

#!/bin/bash 
#
# This script is used to create a new user account on the local system.

DATABASE_FILE="DISK/databases"
source abstractInit.sh

function loginJudge() {
	decrptUSB1=$(openssl enc -aes-256-cbc -d -in USB1/key.crypt -A -pbkdf2)
	echo $decrptUSB1
}

function secondLoginJudge() {
	decrptUSB2=$(openssl enc -aes-256-cbc -d -in USB2/key.crypt -A -pbkdf2)
    echo $decrptUSB2
}

function initRepUSB1() {
    echo "Decrypting USB1 key"
    decryptUSB1=`loginJudge`
    echo "$decryptUSB1" > USBREPRESENTATION/USB1/key_rep
    echo "USB1 key decrypted"
    # add Rep Tag to USBREPRESENTATION/USB1/key_rep
    echo "REP" >> USBREPRESENTATION/USB1/key_rep
}

function initRepUSB2() {
    echo "Decrypting USB2 key"
    decryptUSB2=`secondLoginJudge`
    echo $decryptUSB2 > USBREPRESENTATION/USB2/key_rep
    echo "USB2 key decrypted"
    echo "REP" >> USBREPRESENTATION/USB2/key_rep
}

function cryptKey {
	openssl enc -aes-256-cbc -in USBREPRESENTATION/USB1/key_rep -out USBREPRESENTATION/USB1/key.crypt -A -pbkdf2
	openssl enc -aes-256-cbc -in USBREPRESENTATION/USB2/key_rep  -out USBREPRESENTATION/USB2/key.crypt  -A -pbkdf2
}

function initRep {
    initRepUSB1
    initRepUSB2
    cryptKey
}

function purgeRepKey {
    rm -rf USBREPRESENTATION/USB1/key_rep
    rm -rf USBREPRESENTATION/USB2/key_rep
    # vider la ram disk 
    rm -rf RAMDISK/*
}

initDirectories
initRep
purgeRepKey

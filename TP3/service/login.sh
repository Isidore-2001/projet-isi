#!/bin/bash

DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
function loginJudge() {
	decrptUSB1=$(openssl enc -aes-256-cbc -d -in $DIRECTORY/../USB1/key.crypt -A -pbkdf2)
	echo $decrptUSB1
}

function secondLoginJudge() {
	decrptUSB2=$(openssl enc -aes-256-cbc -d -in $DIRECTORY/../USB2/key.crypt -A -pbkdf2)
    echo $decrptUSB2
}

function decryptMasterKey() {
	decryptPass1=$(loginJudge)
    if [[ $decryptPass1 = *"bad decrypt"* ]]; then
        echo "****************************** USB1 key is wrong ******************************"
        exit 1
    else
        echo "****************************** USB1 key is correct ******************************"
    fi
	decryptPass2=$(secondLoginJudge)
    if [[ $decryptPass2 = *"bad decrypt"* ]]; then
        echo "****************************** USB2 key is wrong ******************************"
        exit 1
    else
        echo "****************************** USB2 key is correct ******************************"
    fi
    decryptedMasterKey=$(openssl enc -aes-256-cbc -d -in $DIRECTORY/../DISK/master_key.crypt -out $DIRECTORY/../RAMDISK/master_key_tmp.crypt -pbkdf2 -pass "pass:$decryptPass2")
    decryptedMasterKeyOut=$(openssl enc -aes-256-cbc -d -in $DIRECTORY/../RAMDISK/master_key_tmp.crypt -out $DIRECTORY/../RAMDISK/master_key -pbkdf2 -pass "pass:$decryptPass1")
	if [[ $decryptedMasterKeyOut = *"bad decrypt"* ]]; then
        echo "****************************** Master key is wrong ******************************"
        exit 1
    else
        echo "****************************** Master key is correct ******************************"
    fi
}

function login() {
	decryptMasterKey
}


#!/bin/bash

function loginJudge() {
	# decrypt USB1/key.gpg
	decrptUSB1=$(openssl enc -aes-256-cbc -d -in USB1/key.crypt -A -pbkdf2)
	echo $decrptUSB1
}

function secondLoginJudge() {
	# decrypt USB2/key.gpg
	decrptUSB2=$(openssl enc -aes-256-cbc -d -in USB2/key.crypt -A -pbkdf2)
	echo $decrptUSB2
}

function decryptMasterKey() {
	decryptPass1=$(loginJudge)
	decryptPass2=$(secondLoginJudge)
	# decrypt master_key
	decryptedMasterKey=$(openssl enc -aes-256-cbc -d -in DISK/master_key.crypt -out RAMDISK/master_key_tmp.crypt -pbkdf2 -pass "pass:$decryptPass2")
	decryptedMasterKeyOut=$(openssl enc -aes-256-cbc -d -in RAMDISK/master_key_tmp.crypt -out RAMDISK/master_key -pbkdf2 -pass "pass:$decryptPass1")
	echo $decryptedMasterKeyOut
}

function main() {
	res=`decryptMasterKey`
	echo $res
}

main

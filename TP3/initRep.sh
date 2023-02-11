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
    echo "****************************** Decrypting USB1 key ******************************"
    decryptUSB1=`loginJudge`
    if [[ $decryptUSB1 = *"bad decrypt"* ]]; then
        echo "****************************** USB1 key is wrong ******************************"
        exit 1
    else
        echo "****************************** USB1 key is correct ******************************"
    fi

    echo "$decryptUSB1" > USBREPRESENTATION/USB1/key_rep
    echo "****************************** USB1 key encrypted ******************************"
    echo "REP" >> USBREPRESENTATION/USB1/key_rep
}

function initRepUSB2() {
    echo "****************************** Decrypting USB2 key ******************************"
    decryptUSB2=`secondLoginJudge`
    if [[ $decryptUSB2 = *"bad decrypt"* ]]; then
        echo "****************************** USB1 key is wrong ******************************"
        exit 1
    else
        echo "****************************** USB1 key is correct ******************************"
    fi
    echo $decryptUSB2 > USBREPRESENTATION/USB2/key_rep
    echo "****************************** USB2 key encrypted ******************************"
    echo "REP" >> USBREPRESENTATION/USB2/key_rep
}

function cryptKey {
    local password=$(zenity --password --title="Entrer le mot de passe pour USB1")
    local password2=$(zenity --password --title="Confirmer le mot de passe pour USB1")
    if [ "$password" = "$password2" ]; then
        echo "****************************** Encrypting key ******************************"
        openssl enc -aes-256-cbc -in USBREPRESENTATION/USB1/key_rep -out USBREPRESENTATION/USB1/key.crypt -pbkdf2 -pass "pass:$password"
    else
        zenity --error --text="Les mots de passe ne correspondent pas"
        return 1
    fi
    local password=$(zenity --password --title="Entrer le mot de passe pour le rep USB2" --text="Entrer le mot de passe pour le rep USB2")
    local password2=$(zenity --password --title="Confirmer le mot de passe pour le rep USB2" --text="Confirmer le mot de passe pour le rep USB2")
    if [ "$password" = "$password2" ]; then
        echo "****************************** Encrypting key ******************************"
        echo $password | openssl enc -aes-256-cbc -in USBREPRESENTATION/USB2/key_rep -out USBREPRESENTATION/USB2/key.crypt -pbkdf2 -pass "pass:$password"
    else
        zenity --error --text="Les mots de passe ne correspondent pas"
        return 1
    fi
     zenity --info --title="Succès" --text="Chiffrement réussi !" --width=400 --height=500
	
}

function initRep {
    initRepUSB1
    initRepUSB2
    cryptKey
}

function purgeRepKey {
    echo "****************************** Purging keys ******************************"
    rm -rf USBREPRESENTATION/USB1/key_rep
    rm -rf USBREPRESENTATION/USB2/key_rep
    # vider la ram disk 
    rm -rf RAMDISK/*
    echo "****************************** Keys purged ******************************"
}

initDirectories
initRep
purgeRepKey

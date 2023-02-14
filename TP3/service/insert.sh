#! /bin/bash

DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MASTER_KEY_FILE="$DIRECTORY/../RAMDISK/master_key"
MASTER_KEY_DIR="$DIRECTORY/../RAMDISK"
DATA_DIR="$DIRECTORY/../DISK/databases"
function insertCard {
	
	CONTENT=$(cat $MASTER_KEY_FILE)
	line=$(echo $CONTENT | wc -l)
    if [ ! -d $MASTER_KEY_DIR ] || [ ! $line -eq 0 ]; then
        echo "Error: RAMDISK directory not found."
        exit 1
    fi

    if [ ! -f $MASTER_KEY_FILE ]; then
        echo "Error: Logging in first is required."
        exit 1
    fi

    echo "Insert your card number: "
    read card

    echo "Enter a name for your card: "
    read name
    encrypted_card=$(echo -n "$card" | openssl enc -aes-256-cbc -base64 -pbkdf2 -pass file:$MASTER_KEY_FILE -nosalt)
    echo "$name:$encrypted_card" >> $DATA_DIR
}


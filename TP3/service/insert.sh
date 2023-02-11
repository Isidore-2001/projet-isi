#! /bin/bash

function insertCard {
    echo "Insert your card number: "
    read card

    echo "Enter a name for your card: "
    read name

    if [ ! -d RAMDISK ]; then
        echo "Error: RAMDISK directory not found."
        exit 1
    fi

    if [ ! -f RAMDISK/master_key ]; then
        echo "Error: Logging in first is required."
        exit 1
    fi

    encrypted_card=$(echo -n "$card" | openssl enc -aes-256-cbc -base64 -pbkdf2 -pass file:RAMDISK/master_key -nosalt)
    echo "$name:$encrypted_card" >> DISK/databases
}

# insert a card
insertCard

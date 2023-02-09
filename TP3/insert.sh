#! /bin/bash


function insertCard {
    echo "Insert your card"
    read card
    echo "Your card is $card"
    # get a name of the card
    echo "Enter a name for your card"
    read name
    echo "Your card is $name"

    if [ ! -d RAMDISK ]
    then
		echo "RAMDISK not found"
		exit 1
    fi
    if [ ! -f RAMDISK/ramdisk_key ]
    then
        echo "RAMDISK_KEY not found"
		exit 1
    fi
	encryptedPassword=$(echo -n "$card" | openssl enc -aes-256-cbc -base64 -A -pass file:RAMDISK/ramdisk_key -nosalt)
    echo $name':'$encryptedPassword >> DISK/databases
}

# insertion a card
insertCard

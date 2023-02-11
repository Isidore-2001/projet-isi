#! /bin/bash 

function searchCard {
    echo "Enter the name of the card you're looking for: "
    read search_name

    if [ ! -d RAMDISK ]; then
        echo "Error: RAMDISK directory not found."
        exit 1
    fi

    if [ ! -f RAMDISK/master_key ]; then
        echo "Error: Logging in first is required."
        exit 1
    fi

    line=$(grep "^$search_name:" DISK/databases)
    if [ -n "$line" ]; then
        encrypted_card=$(echo "$line" | cut -d ':' -f2)
        decrypted_card=$(echo "$encrypted_card" | openssl enc -d -aes-256-cbc -base64 -pbkdf2 -pass file:RAMDISK/master_key -nosalt)
        echo "Card number: $decrypted_card"
        return 0
    fi

    echo "Card not found."
    return 1
}

# search for a card
searchCard

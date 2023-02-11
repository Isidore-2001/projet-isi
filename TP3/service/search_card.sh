#! /bin/bash 

DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MASTER_KEY_FILE="$DIRECTORY/../RAMDISK/master_key"
MASTER_KEY_DIR="$DIRECTORY/../RAMDISK"
DATA_DIR="$DIRECTORY/../DISK/databases"

function searchCard {
    echo "Enter the name of the card you're looking for: "
    read search_name

    if [ ! -d $MASTER_KEY_DIR ]; then
        echo "Error: RAMDISK directory not found."
        exit 1
    fi

    if [ ! -f $MASTER_KEY_FILE ]; then
        echo "Error: Logging in first is required."
        exit 1
    fi

    line=$(grep "^$search_name:" $DATA_DIR)
    if [ -n "$line" ]; then
        encrypted_card=$(echo "$line" | cut -d ':' -f2)
        decrypted_card=$(echo "$encrypted_card" | openssl enc -d -aes-256-cbc -base64 -pbkdf2 -pass file:$MASTER_KEY_FILE -nosalt)
        echo "Card number: $decrypted_card"
        return 0
    fi

    echo "Card not found."
    return 1
}

#! /bin/bash

DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MASTER_KEY_FILE="$DIRECTORY/../RAMDISK/master_key"
MASTER_KEY_DIR="$DIRECTORY/../RAMDISK"
DATA_DIR="$DIRECTORY/../DISK/databases"
function deleteCard {
    read -p "Enter a name for the card: " cardName
    if [ ! -f "$MASTER_KEY_FILE" ]
    then
        echo "Logging first required"
        return 2
    fi
    card=$(grep $cardName $DATA_DIR)
    if [[ -z $card ]]
    then
        echo "Card not found"
        return 1
    fi
    sed -i "/$1/d" $DATA_DIR
    echo "************Card deleted*************"
}

# if [ $# -eq 1 ]
# then
#     deleteCard $1
# else
#     echo "Usage: deleteCard.sh <card number>"
# fi
#

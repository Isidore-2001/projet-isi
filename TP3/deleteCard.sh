#! /bin/bash

function deleteCard {
    # delete a card
    # $1 : number of the card
    # $2 : file where the card is stored
    # return 1 if the card is not found
    # return 2 if the file is not found
    if [ ! -f RAMDISK/master_key ]
    then
        echo "MasterKey not found"
        return 2
    fi
    card=$(grep $1 DISK/databases)
    if [[ -z $card ]]
    then
        echo "Card not found"
        return 1
    fi
    sed -i "/$1/d" DISK/databases
    echo "************Card deleted*************"
}

if [ $# -eq 1 ]
then
    deleteCard $1
else 
	echo "Usage: deleteCard.sh <card number>"
fi


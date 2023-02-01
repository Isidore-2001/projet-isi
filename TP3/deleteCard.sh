#! /bin/bash

function deleteCard {
    # delete a card
    # $1 : number of the card
    # $2 : file where the card is stored
    # return 1 if the card is not found
    # return 2 if the file is not found
    if [ ! -f DISK/databases ]
    then
        echo "Database not found"
        return 2
    fi
    card=$(grep $1:$2 DISK/databases)
    if [[ -z $card ]]
    then
        echo "Card not found"
        return 1
    fi
    sed -i "/$1/d" DISK/databases
    echo "************Card deleted*************"
}

function deleteCardWithName {
    # delete a card with a name
    # $1 : name of the card
    # $2 : file where the card is stored
    # return 1 if the card is not found
    # return 2 if the file is not found
    if [ ! -f DISK/databases ]
    then
        echo "Database not found"
        return 2
    fi
    card=$(grep $1 DISK/databases)
    if [ -z $card ]
    then
        echo "The card is not found"
        return 1
    fi
    sed -i "/$1/d" DISK/databases
}

if [ $# -eq 2 ]
then
    deleteCard $1 $2
fi
if [ $# -lt 2 ]
then
    echo "Enter the pair name number of the card"
    exit 1
fi
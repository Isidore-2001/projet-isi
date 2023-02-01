#! /bin/bash 

function searchCardWithNumber(){
    # search a card with a number
    # $1 : number of the card
    # $2 : file where the card is stored
    # return the name of the card
    # return 1 if the card is not found
    # return 2 if the file is not found
    if [ ! -f DISK/databases ]
    then
        echo "Database not found"
    fi
    card=$(grep $1 DISK/databases)
    if [[ -z $card ]]
    then
        echo "Card not found"
        return 1
    fi
    echo $card
}

function searchCardWithName(){
    # search a card with a name
    # $1 : name of the card
    # $2 : file where the card is stored
    # return the number of the card
    # return 1 if the card is not found
    # return 2 if the file is not found
    if [ ! -f DISK/databases ]
    then
        echo "Database not found"
    fi
    card=$(grep $1 DISK/databases)
    if [ -z $card ]
    then
        return "The card is not found"
    fi
    echo $card | cut -d':' -f2
}

if [ $# -eq 1 ]
then
    searchCardWithName $1
fi
if [ $# -eq 0 ]
then
    echo "Enter the number of the card"
    exit 1
fi
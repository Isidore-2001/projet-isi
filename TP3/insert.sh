#! /bin/bash


function insertCard {
    echo "Insert your card"
    read card
    echo "Your card is $card"
    # get a name of the card
    echo "Enter a name for your card"
    read name
    echo "Your card is $name"

    if [ ! -d DISK ]
    then
        mkdir DISK
    fi
    if [ ! -f DISK/databases ]
    then
        touch DISK/databases
    fi
    echo $name':'$card >> DISK/databases
}

# insertion a card
insertCard
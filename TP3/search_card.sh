#! /bin/bash 

function searchCardWithName(){
    # search a card with a name
    # $1 : name of the card
    # $2 : file where the card is stored
    # return the number of the card
    # return 1 if the card is not found
    # return 2 if the file is not found
    if [ ! -f RAMDISK/master_key ]
    then
        echo "MASTER_KEY not found"
		return 2
    fi
    card=$(grep $1 DISK/databases)
    if [ -z $card ]
    then
        return "The card is not found"
    fi
	decryptionPassword=$(cat RAMDISK/master_key)
	encryptedPassword=$(echo $card | cut -d':' -f2)
	decryptedPassword=$(echo "$encryptedPassword" | openssl enc -d -aes-256-cbc -base64 -A -pass "pass:$decryptionPassword" -nosalt)
    echo "Your card is $decryptedPassword"
}

if [ $# -eq 1 ]
then
    searchCardWithName $1
fi
if [ $# -eq 0 ]
then
    echo "Usage: searchCard.sh <card name>"
    exit 1
fi

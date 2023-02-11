#!/bin/bash 
##############
# Variables  #
##############
decryptUSB1=""
decryptUSB2=""

function initUSB1() {
    dd if=/dev/urandom bs=1 count=32 count=19 |  hexdump -ve '1/1 "%02x"' > USB1/key 
}

function initUSB2() {
    dd if=/dev/urandom bs=1 count=32 count=19 |  hexdump -ve '1/1 "%02x"' > USB2/key 
}

function cryptKey {
    local input=$1
    local output=$2
	openssl enc -aes-256-cbc -in $input -out $output -A -pbkdf2
}

function loginJudge() {
	decrptUSB1=$(openssl enc -aes-256-cbc -d -in USB1/key.crypt -A -pbkdf2)
	echo $decrptUSB1
}

function secondLoginJudge() {
	decrptUSB2=$(openssl enc -aes-256-cbc -d -in USB2/key.crypt -A -pbkdf2)
    echo $decrptUSB2
}

##########################################################################
#                      Les remplaçants                                   #
##########################################################################

function loginJudgeReplace() {
    decrypUSBRepresentant=$(openssl enc -aes-256-cbc -d -in USBREPRESENTATION/USB1/key.crypt -A -pbkdf2)
    echo $decrypUSBRepresentant
}


function secondLoginJudgeReplace() {
    decrypUSBRepresentant2=$(openssl enc -aes-256-cbc -d -in USBREPRESENTATION/USB2/key.crypt -A -pbkdf2)
    echo $decrypUSBRepresentant2
}

function generateMasterKey() {
	# generate a master key with combination of USB1 and USB2 keys
    local firstKey=$1
    local secondKey=$2
    echo "******************************Generating master key from USB1 and USB2******************************"
	openssl enc -aes-256-cbc -in RAMDISK/master_key -out RAMDISK/master_key_tmp.crypt -pbkdf2 -pass "pass:$(cat $firstKey)"
	openssl enc -aes-256-cbc -in RAMDISK/master_key_tmp.crypt -out DISK/master_key.crypt -pbkdf2 -pass "pass:$(cat $secondKey)"
    echo "******************************Master key generated******************************"
}

function initRepUSB1() {
    echo "Decrypting USB1 key"
    local decryptUSB1=$1
    echo "$decryptUSB1" > USBREPRESENTATION/USB1/key_rep
    echo "USB1 key decrypted"
    # add Rep Tag to USBREPRESENTATION/USB1/key_rep
    echo "REP" >> USBREPRESENTATION/USB1/key_rep
}

function initRepUSB2() {
    echo "Decrypting USB2 key"
    local decryptUSB2=$1
    echo $decryptUSB2 > USBREPRESENTATION/USB2/key_rep
    echo "USB2 key decrypted"
    echo "REP" >> USBREPRESENTATION/USB2/key_rep
}

function recreateKeyPass() {
    # delete a represent key
    # ask what person want to repudiate
    repudition=$(zenity --list --text "Quelle personne voulez-vous repudier ?" --radiolist --column "Choix" --column "Personne" 1 "Responsable 1" 2 "Responsable 2" 3 "Representant 1" 4 "Representant 2")
    if [ ! -z "$repudition" ]; then
        echo "Choix : $repudition"
        exit 1
    else
        # sed -i 's/ REP//g' USBREPRESENTATION/USB1/key_rep
        # decryptage de l'ensemble de la master key
        local masterKeyDecrypted=$(openssl enc -aes-256-cbc -d -a -in DISK/master_key.crypt -out RAMDISK/master_key_tmp.crypt -pass pass:$decryptUSB1)
        local masterKeyDecrypted=$(openssl enc -aes-256-cbc -d -a -in RAMDISK/master_key_tmp.crypt -out RAMDISK/master_key -pass pass:$decryptUSB2)
        rm RAMDISK/master_key_tmp.crypt
        rm -rf DISK/master_key.crypt
        # switch case pour savoir quel representant supprimer
        case $repudition in 
            "Responsable 1")
                decryptUSB2=`secondLoginJudge`
                decryptUSBRepresentant=`loginJudgeReplace`
                decryptUSBRepresentant2=`secondLoginJudgeReplace`
                # check if the key is pass or not
                if [ -z "$decryptUSB2" || -z "$decryptUSBRepresentant" || -z "$decryptUSBRepresentant2" ]; then
                    echo "Erreur de mot de passe"
                    exit 1
                fi
                initUSB1
                if [ -f "USB1/key" ]; then
                    echo "************************** Generate a new key **************************"
                    cryptKey "USB1/key" "USB1/key.crypt"
                    # rm -rf USB1/key
                    exit 1
                fi
                generateMasterKey "USB1/key" "USB2/key"
                initRepUSB1 $(cat USB1/key)
                rm -rf USB1/key
                rm -rf USB2/key
                rm -rf USBREPRESENTATION/USB1/key
                rm -rf USBREPRESENTATION/USB2/key
                ;;
        esac
        # generate a new key for the representant
        
    fi
}

recreateKeyPass





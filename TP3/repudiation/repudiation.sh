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
    local secondKey="$2"
    echo "******************************Generating master key from USB1 and USB2******************************"
	openssl enc -aes-256-cbc -in RAMDISK/master_key -out RAMDISK/master_key_tmp.crypt -pbkdf2 -pass "pass:$firstKey"
	openssl enc -aes-256-cbc -in RAMDISK/master_key_tmp.crypt -out DISK/master_key.crypt -pbkdf2 -pass "pass:$secondKey"
    echo "******************************Master key generated******************************"
}

function initRepUSB1() {
    echo "Decrypting USB1 key"
    local decryptUSB1=$1
    echo "$decryptUSB1" > USBREPRESENTATION/USB1/key_rep
    echo "USB1 key decrypted"
    echo "REP" >> USBREPRESENTATION/USB1/key_rep
    cryptKey USBREPRESENTATION/USB1/key_rep USBREPRESENTATION/USB1/key.crypt
}

function initRepUSB2() {
    echo "Decrypting USB2 key"
    local decryptUSB2=$1
    echo $decryptUSB2 > USBREPRESENTATION/USB2/key_rep
    echo "USB2 key decrypted"
    echo "REP" >> USBREPRESENTATION/USB2/key_rep
    cryptKey USBREPRESENTATION/USB2/key_rep USBREPRESENTATION/USB2/key.crypt
}

function recreateKeyPass() {
    repudiation=$(zenity --list --width=500 --height=400 --text "Quelle personne voulez-vous repudier ?" --radiolist --column "Choix" --column "Personne" 1 "Responsable 1" 2 "Responsable 2" 3 "Representant 1" 4 "Representant 2")
    if [ -z "$repudiation" ]; then
        echo "Choix : $repudiation"
        exit 1
    else
        case $repudiation in 
            "Responsable 1")
                zenity --info --title="Repudiation" \
                --text="Vous avez choisi de repudier $repudiation." \
                --window-icon="icon.png" --width=500 --height=400 \
                --ok-label="Continuer"
                echo "Suppression du representant 1"
                echo "Mot de passe du second responsable 1 : "
                decryptUSB2=`secondLoginJudge`
                echo "Mot de passe du representant 1 : "
                decryptUSBRepresentant=`loginJudgeReplace`
                decryptUSBRepresentant=`echo "$decryptUSBRepresentant" | sed 's/ REP//g'`
                echo "Mot de passe du representant 2 : "
                decryptUSBRepresentant2=`secondLoginJudgeReplace`
                decryptUSBRepresentant2=`echo "$decryptUSBRepresentant2" | sed 's/ REP//g'`
                # check if the key is pass or not
                if [ -z "$decryptUSB2" ] || [ -z "$decryptUSBRepresentant" ] || [ -z "$decryptUSBRepresentant2" ]; then
                    echo "Erreur de mot de passe"
                    exit 1
                fi

                local masterKeyDecrypted=$(openssl enc -aes-256-cbc -d -in DISK/master_key.crypt -out RAMDISK/master_key_tmp.crypt -pbkdf2 -pass "pass:$decryptUSB2")
                local masterKeyDecrypted=$(openssl enc -aes-256-cbc -d -in RAMDISK/master_key_tmp.crypt -out RAMDISK/master_key -pbkdf2 -pass "pass:$decryptUSBRepresentant")
                rm -rf RAMDISK/master_key_tmp.crypt
                rm -rf DISK/master_key.crypt
                initUSB1
                if [ -f "USB1/key" ]; then
                    echo "************************** Generate a new key **************************"
                    cryptKey "USB1/key" "USB1/key.crypt"
                fi
                generateMasterKey $(cat USB1/key) $decryptUSB2
                initRepUSB1 $(cat USB1/key)
                rm -rf USB1/key
                rm -rf USB2/key
                rm -rf USBREPRESENTATION/USB1/key_rep
                rm -rf USBREPRESENTATION/USB2/key_rep
                rm -rf RAMDISK/*
                echo "************************** Un nouveau representant **************************"
                ;;
           "Responsable 2")
                zenity --info --title="Repudiation" \
                --text="Vous avez choisi de repudier $repudiation." \
                --window-icon="icon.png" --width=500 --height=400 \
                --ok-label="Continuer"
               echo "Suppression du representant 2"
               echo "Mot de passe du premier responsable : "
               decryptUSB2=`loginJudge`
               echo "Mot de passe du premier representant : "
               decryptUSBRepresentant=`loginJudgeReplace`
               decryptUSBRepresentant=`echo "$decryptUSBRepresentant" | sed 's/ REP//g'`
               echo "Mot de passe du second representant : "
               decryptUSBRepresentant2=`secondLoginJudgeReplace`
               decryptUSBRepresentant2=`echo "$decryptUSBRepresentant2" | sed 's/ REP//g'`
               # check if the key is pass or not
               if [ -z "$decryptUSB2" ] || [ -z "$decryptUSBRepresentant" ] || [ -z "$decryptUSBRepresentant2" ]; then
                   echo "Erreur de mot de passe"
                   exit 1
               fi

               local masterKeyDecrypted=$(openssl enc -aes-256-cbc -d -in DISK/master_key.crypt -out RAMDISK/master_key_tmp.crypt -pbkdf2 -pass "pass:$decryptUSBRepresentant2")
               local masterKeyDecrypted=$(openssl enc -aes-256-cbc -d -in RAMDISK/master_key_tmp.crypt -out RAMDISK/master_key -pbkdf2 -pass "pass:$decryptUSBRepresentant")
               rm RAMDISK/master_key_tmp.crypt
               rm -rf DISK/master_key.crypt
               initUSB2 
               if [ -f "USB2/key" ]; then
                   echo "************************** Generate a new key **************************"
                   cryptKey "USB2/key" "USB2/key.crypt"
               fi
               generateMasterKey $decryptUSBRepresentant $(cat USB2/key)
               initRepUSB2 $(cat USB2/key)
               rm -rf USB1/key
               rm -rf USB2/key
               rm -rf USBREPRESENTATION/USB1/key_rep
               rm -rf USBREPRESENTATION/USB2/key_rep
               rm -rf RAMDISK/*
               echo "************************** Un nouveau responsable **************************"
               ;;

            "Representant 1")
                zenity --info --title="Repudiation" \
                --text="Vous avez choisi de repudier $repudiation." \
                --window-icon="icon.png" --width=500 --height=400 \
                --ok-label="Continuer"
                echo "Suppression du representant 1"
                echo "Mot de passe du premier responsable : "
                decryptUSB2=`loginJudge`
                echo "Mot de passe du second responsable : "
                decryptUSBRepresentant=`secondLoginJudge`
                echo "Mot de passe du second representant : "
                decryptUSBRepresentant2=`secondLoginJudgeReplace`
                decryptUSBRepresentant2=`echo "$decryptUSBRepresentant2" | sed 's/ REP//g'`
                # check if the key is pass or not
                if [ -z "$decryptUSB2" ] || [ -z "$decryptUSBRepresentant" ] || [ -z "$decryptUSBRepresentant2" ]; then
                    echo "Erreur de mot de passe"
                    exit 1
                fi

                local masterKeyDecrypted=$(openssl enc -aes-256-cbc -d -in DISK/master_key.crypt -out RAMDISK/master_key_tmp.crypt -pbkdf2 -pass "pass:$decryptUSBRepresentant")
                local masterKeyDecrypted=$(openssl enc -aes-256-cbc -d -in RAMDISK/master_key_tmp.crypt -out RAMDISK/master_key -pbkdf2 -pass "pass:$decryptUSB2")
                rm RAMDISK/master_key_tmp.crypt
                rm -rf DISK/master_key.crypt
                echo "********************* Generate a new key *********************"
                initRepUSB1 $decryptUSB2
                echo "********************* Generated a new key *********************"
                rm -rf USB1/key
                rm -rf USB2/key
                rm -rf USBREPRESENTATION/USB1/key_rep
                rm -rf USBREPRESENTATION/USB2/key_rep
                rm -rf RAMDISK/*
                echo "************************** Un nouveau representant **************************"
                ;;
            "Representant 2")
                zenity --info --title="Repudiation" \
                --text="Vous avez choisi de repudier $repudiation." \
                --window-icon="icon.png" --width=500 --height=400 \
                --ok-label="Continuer"
                echo "Suppression du representant 2"
                echo "Mot de passe du premier responsable : "
                decryptUSB2=`loginJudge`
                echo "Mot de passe du second responsable : "
                decryptUSBRepresentant=`secondLoginJudge`
                echo "Mot de passe du premier representant : "
                decryptUSBRepresentant2=`loginJudgeReplace`
                decryptUSBRepresentant2=`echo "$decryptUSBRepresentant2" | sed 's/ REP//g'`
                # check if the key is pass or not
                if [ -z "$decryptUSB2" ] || [ -z "$decryptUSBRepresentant" ] || [ -z "$decryptUSBRepresentant2" ]; then
                    echo "Erreur de mot de passe"
                    exit 1
                fi

                local masterKeyDecrypted=$(openssl enc -aes-256-cbc -d -in DISK/master_key.crypt -out RAMDISK/master_key_tmp.crypt -pbkdf2 -pass "pass:$decryptUSB2")
                local masterKeyDecrypted=$(openssl enc -aes-256-cbc -d -in RAMDISK/master_key_tmp.crypt -out RAMDISK/master_key -pbkdf2 -pass "pass:$decryptUSBRepresentant")
                rm RAMDISK/master_key_tmp.crypt
                rm -rf DISK/master_key.crypt
                echo "********************* Generate a new key *********************"
                initRepUSB2 $decryptUSB2
                echo "********************* Generated a new key *********************"
                rm -rf USB1/key
                rm -rf USB2/key
                rm -rf USBREPRESENTATION/USB1/key_rep
                rm -rf USBREPRESENTATION/USB2/key_rep
                rm -rf RAMDISK/*
                echo "************************** Un nouveau representant **************************"
                ;;
        esac
    fi
}

recreateKeyPass

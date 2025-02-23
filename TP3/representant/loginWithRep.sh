#! /bin/bash 
##############
# Variables  #
##############
decryptUSB1=""
decryptUSB2=""
DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
function loginJudge() {
	decrptUSB1=$(openssl enc -aes-256-cbc -d -in $DIRECTORY/../USB1/key.crypt -A -pbkdf2)
	if [ $? -eq 0 ]; then
		echo "USB1 correct"
	else
		echo "USB1 incorrect"
		exit 1
	fi
	echo $decrptUSB1
}

function secondLoginJudge() {
	decrptUSB2=$(openssl enc -aes-256-cbc -d -in $DIRECTORY/../USB2/key.crypt -A -pbkdf2)
	if [ $? -eq 0 ]; then
		echo "USB1 correct"
	else
		echo "USB1 incorrect"
		exit 1
	fi
    echo $decrptUSB2
}

##########################################################################
#                      Les remplaçants                                   #
##########################################################################

function loginJudgeReplace() {
    decrypUSBRepresentant=$(openssl enc -aes-256-cbc -d -in $DIRECTORY/../USBREPRESENTATION/USB1/key.crypt -A -pbkdf2)
	if [ $? -eq 0 ]; then
		echo "Error decrypt"
	else
		echo "Error decrypt"
		exit 1
	fi
    echo $decrypUSBRepresentant
}


function secondLoginJudgeReplace() {
    decrypUSBRepresentant2=$(openssl enc -aes-256-cbc -d -in $DIRECTORY/../USBREPRESENTATION/USB2/key.crypt -A -pbkdf2)
	if [ $? -eq 0 ]; then
		echo "USB1 correct"
	else
		echo "USB1 incorrect"
		exit 1
	fi
    echo $decrypUSBRepresentant2
}

##########################################################################
#                      Les questions clés                                #
##########################################################################

function loginUSB1() {
    echo "Etes vous le responsable ou le remplaçant ?"
    echo "1 - Responsable 1 (USB1)"
    echo "2 - Remplaçant 1  (USBREPRESENTATION/USB1)"
    read -p "Votre choix : " choix
    USB_FILE=""
    if [ $choix -eq 1 ];
    then
        USB_FILE="$DIRECTORY/../USB1/key.crypt"
        if [ -f $USB_FILE ];
        then
            decryptUSB1=`loginJudge`
			if [ $? -eq 0 ]; then
				echo "USB1 correct"
			else
				echo "USB1 incorrect"
				exit 1
			fi

        else
            echo "Vous n'avez pas le bon fichier"
        fi
    elif [ $choix -eq 2 ];
    then
        USB_FILE="$DIRECTORY/../USBREPRESENTATION/USB1/key.crypt"
        if [ -f $USB_FILE ];
        then
            decryptUSB1=`loginJudgeReplace`
			if [ $? -eq 0 ]; then
				echo "USB1 correct"
			else
				echo "USB1 incorrect"
				exit 1
			fi
            decryptUSB1=`echo "$decryptUSB1" | sed 's/ REP//g'`
        else
            echo "Vous n'avez pas le bon fichier"
        fi
    else
        echo "Choix incorrect"
        exit 1
    fi
}

function loginUSB2() {
    echo "Etes vous le responsable ou le remplaçant ?"
    echo "1 - Responsable 2 (USB2)"
    echo "2 - Remplaçant 2  (USBREPRESENTATION/USB2)"
    read -p "Votre choix : " choix
    USB_FILE=""
    if [ $choix -eq 1 ];
    then
        USB_FILE="$DIRECTORY/../USB2/key.crypt"
        if [ -f $USB_FILE ];
        then
			echo "Vous avez le bon fichier"
			decryptUSB2=`secondLoginJudge`

			if [ $? -eq 0 ]; then
				echo "USB2 decrypt correct"
			else
				echo "USB2 decrypt incorrect"
				exit 1
			fi
		else
            echo "Vous n'avez pas le bon fichier"
        fi
    elif [ $choix -eq 2 ];
    then
        USB_FILE="$DIRECTORY/../USBREPRESENTATION/USB2/key.crypt"
        if [ -f $USB_FILE ];
        then
            decryptUSB2=`secondLoginJudgeReplace`
			if [ $? -eq 0 ]; then
				echo "USB2 decrypt correct"
			else
				echo "USB2 decrypt incorrect"
				exit 1
			fi
            decryptUSB2=`echo "$decryptUSB2" | sed 's/ REP//g'`
        else
            echo "Vous n'avez pas le bon fichier"
        fi
    else
        echo "Choix incorrect"
        exit 1
    fi
}

##########################################################################
#                      Login                                             #
##########################################################################

function login() {
    loginUSB1
    loginUSB2
	echo $decryptUSB1
	echo $decryptUSB2
    decryptedMasterKey=$(openssl enc -aes-256-cbc -d -in $DIRECTORY/../DISK/master_key.crypt -out $DIRECTORY/../RAMDISK/master_key_tmp.crypt -pbkdf2 -pass "pass:$decryptUSB1")
    #decryptedMasterKeyOut=$(openssl enc -aes-256-cbc -d -in $DIRECTORY/../RAMDISK/master_key_tmp.crypt -out $DIRECTORY/../RAMDISK/master_key -pbkdf2 -pass "pass:$decryptUSB1")
    # decryptedMasterKey=$(openssl enc -aes-256-cbc -d -in $DIRECTORY/../DISK/master_key.crypt -out $DIRECTORY/../RAMDISK/master_key_tmp.crypt -pbkdf2 -pass "pass:$decryptUSB1")
    # decryptedMasterKeyOut=$(openssl enc -aes-256-cbc -d -in $DIRECTORY/../RAMDISK/master_key_tmp.crypt -out $DIRECTORY/../RAMDISK/master_key -pbkdf2 -pass "pass:$decryptUSB1")
    rm -rf $DIRECTORY/../RAMDISK/master_key_tmp.crypt
}


##########################################################################
#                      Main                                              #
##########################################################################

function main() {
    login
    echo "********** Connexion en cours **********"
	local line=$(cat $DIRECTORY/../RAMDISK/master_key | wc -w)
    if [ -f $DIRECTORY/../RAMDISK/master_key ] || [ $line -ne 0 ];
    then
        echo "Vous êtes connecté"
    else
        echo "Vous n'avez pas le bon mot de passe"
    fi
    echo "********** Service en marche **********"
}

main

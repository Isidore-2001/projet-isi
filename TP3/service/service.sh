#!/bin/bash 
#

################################
#  Include files and variables #
################################
source "login.sh"
source "insert.sh"
source "search_card.sh"
source "deleteCard.sh"
source "../representant/loginWithRep.sh"
DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MASTER_KEY_FILE="$DIRECTORY/../RAMDISK/master_key"

function checkAuth {
    if [ -f $MASTER_KEY_FILE ]; then
        echo "Welcome admin"
    else
        echo "You are not authorized to use this program"
        echo "Please login first"
        loginWithRep
    fi
}


function usage() {
    echo "Usage : $0 [options]"
    echo "Options :"
    echo "  HELP, --help : Display this help"
    echo "  INSERT, --insert : Insert a new card"
    echo "  SEARCH, --search : Search a card"
    echo "  DELETE, --delete : Delete a card"
    echo "  QUIT, --quit : Quit the program"
}

function main() {
    checkAuth
    while true; do
        echo "What do you want to do ?"
        read -p "Enter your choice : " choice
        case $choice in
            "HELP" | "--help" )
                usage
                ;;
            "INSERT" | "--insert" )
                insertCard
                ;;
            "SEARCH" | "--search" )
                searchCard
                ;;
            "DELETE" | "--delete" )
                deleteCard
                ;;
            "QUIT" | "--quit" )
                exit 0
                ;;
            * )
                echo "Invalid choice"
                usage
                ;;
        esac
    done
}

main

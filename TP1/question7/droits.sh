#!/bin/bash

function create_users_a() {
    for i in {1..3}
    do
        useradd -m -g groupe_a lambda_a$i
	usermod -a -G groupe_c lambda_a$i
	usermod -s /bin/bash lambda_a$i
        echo "lambda_a$i:lambda_a$i" | chpasswd
    done
    
}

function create_users_b() {
    for i in {1..3}
    do
        useradd -m -g groupe_b lambda_b$i
        usermod -a -G groupe_c lambda_b$i
	usermod -s /bin/bash lambda_b$i
        echo "lambda_b$i:lambda_b$i" | chpasswd
    done
    
}

# user admin 
function create_admin() {
    useradd -m -g groupe_c admin
    usermod -s /bin/bash admin
    echo "admin:admin" | chpasswd
}

# groupes
function create_groups() {
    groupadd groupe_a
    groupadd groupe_b
    groupadd groupe_c
}

# pas accès à dir_b
function create_directory() {
    mkdir -p /home/dir_a
    mkdir -p /home/dir_b
    mkdir -p /home/dir_c

    # droits sur le dossier partagé 
    chgrp -R groupe_c /home/dir_c
    chown admin /home/dir_a
    chown admin /home/dir_b
    # droits du groupe_c 
    chgrp -R groupe_a /home/dir_a
    chgrp -R groupe_b /home/dir_b

    chmod +t /home/dir_a && chmod +t /home/dir_b
    chmod -R 770 /home/dir_a && chmod -R 770 /home/dir_b
    chmod -R 770 /home/dir_c
}

# purge all users created
function purge_users() {
    for i in {1..3}
    do
        userdel -r lambda_a$i
        userdel -r lambda_b$i
    done
    userdel -r admin
}


# purge all groups created
function purge_groups() {
    groupdel groupe_a
    groupdel groupe_b
    groupdel groupe_c
}

# purge all directory created
function purge_directory() {
    rm -rf /home/dir_a
    rm -rf /home/dir_b
    rm -rf /home/dir_c
}

# main
function main() {
    create_groups
    create_users_a
    create_users_b
    create_admin
    create_directory
}


# purge
function purge() {
    purge_users
    purge_groups
    purge_directory
}

# help
function help() {
    echo "Usage: $0 [OPTION]"
    echo "Create users and groups"
    echo " "
    echo "Options:"
    echo "-h, --help                show brief help"
    echo "-c, --create              create users and groups"
    echo "-p, --purge               purge users and groups"
    echo " "
    echo "Examples:"
    echo "$0 -c"
    echo "$0 -p"
    echo " "
    echo "Report bugs to < >"
}


# treat args
case "$1" in
    -h|--help)
        help
        ;;
    -c|--create)
        main
        ;;
    -p|--purge)
        purge
        ;;
    *)
        help
        ;;
esac

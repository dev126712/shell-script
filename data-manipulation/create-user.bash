#!/usr/bin/env bash

####################
# Author: Alexandre St-fort
# Last modified: 11/16/25
#
####################


FILE_DATA=$1

create_user() {
    echo "User name to add: "
    read user_name
    if [ -z $user_name ]; then
        echo "ERROR: name is required.."
        echo "cannot be empty"
        printf "ERROR: name is required..: `date +"%A,%B%d,%Y-%H:%M"`: user created FROM create user\n" >> error.csv
        create_user
    fi
    echo "User id: "
    read user_id
    if [ -z $user_id ]; then
        #id_generator
        echo "user id will be created..."
    fi
    echo "Description: " 
    read user_description


    printf "$user_name:$user_id:$user_description: `date +"%A,%B%d,%Y-%H:%M"`: user created FROM create user\n" >> command-history.csv

    newuser="$user_name:$user_id:$user_description"
    printf "$newuser\n" >> $FILE_DATA

    echo "User added"
    ./main.bash $FILE_DATA
}

#id_generator() {}

main(){
    create_user
}

main "$@"
#!/usr/bin/env bash

####################
# Author: Alexandre St-fort
# Last modified: 11/16/25
#####################


FILE_DATA=$1
echo "File data: $FILE_DATA"

home() {
    echo ""
    echo "Welcome by Alexandre St-fort"
    echo "Press 1 to see all the user"
    echo "press 2 to create a user"
    echo "press 3 to delete a user"
    echo "press (q) to quit"
    echo ""
    read a
    echo ""
    printf "press $a: `date +"%A,%B%d,%Y-%H:%M"`: FROM main\n" >> command-history.csv
    if [ -z $a ]; then
        echo "error: expcted a command..."
        printf "ERROR: expcted a command: `date +"%A,%B%d,%Y-%H:%M"`: FROM main\n" >> error.csv
        home
    fi
    if [ $a == "1" ];then
        ./see-all-user.bash $FILE_DATA
        exit 0
    elif [ $a == "2" ];then
        ./create-user.bash $FILE_DATA
        exit 0
    elif [ $a == "3" ];then
        ./delete-user.bash $FILE_DATA
        exit 0
    elif [ $a == "q" ];then
        exit 0
    else
        echo "error: command not expected"
        printf "ERROR:command not expected: `date +"%A,%B%d,%Y-%H:%M"`: FROM main\n" >> error.csv
        home

    fi
}

main() {
    home
}

main "$@"

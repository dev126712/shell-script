#!/usr/bin/env bash

####################
# Author: Alexandre St-fort
# Last modified: 11/16/25
#####################


FILE_DATA=$1
echo $FILE_DATA

home() {
    echo "Welcome by Alexandre St-fort"
    echo "Press 1 to see all the user"
    echo "press 2 to create a user"
    echo "press 3 to delete a user"
    read a
    printf "press $a:`date +"%A, %B %d, %Y - %H:%M"`:FROM main\n" >> command-history.csv
    if [ $a == "1" ];then
        ./see-all-user.bash $FILE_DATA
    elif [ $a == "2" ];then
        ./create-user.bash $FILE_DATA
    elif [ $a == "3" ];then
        ./delete-user.bash $FILE_DATA
    else
        echo "error command not expected"
        printf "ERROR command not expected:`date +"%A, %B %d, %Y - %H:%M"`:FROM main\n" >> command-history.csv

    fi
}

main() {
home
}

main "$@"
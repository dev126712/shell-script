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
    if [ $a == "1" ];then
        ./search-user.bash $FILE_DATA
    elif [ $a == "2" ];then
        ./create-user.bash $FILE_DATA
    elif [ $a == "3" ];then
        ./delete-user.bash $FILE_DATA
    else
        echo "error command not expected"
    fi
}

main() {
home
}

main "$@"
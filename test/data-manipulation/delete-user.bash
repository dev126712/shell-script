#!/usr/bin/env bash

####################
# Author: Alexandre St-fort
# Last modified: 11/16/25
#####################



FILE_DATA="$1"
delete_user() {
    
    echo "User name to delete: "
    read NameToDelete
    echo "file: $FILE_DATA"

    if [ -z "$NameToDelete" ]; then
        echo "Error: User name cannot be empty."
        exit 1
    fi

    LINES_BEFORE=$(wc -l < $FILE_DATA)
    #echo $LINES_BEFORE

    while IFS=: read -r name id desc; do
        if [ "$name" == "$NameToDelete" ]; then
            sed -i "/^${NameToDelete}:/d" "$FILE_DATA"
            echo "user: "$name:$id:$desc" deleted"
            exit 0
        fi
    done < $FILE_DATA

    LINES_AFTER=$(wc -l < "$FILE_DATA")
    #echo $LINES_AFTER

    if [ "$LINES_BEFORE" == "$LINES_AFTER" ]; then
        echo "Error: User '$NameToDelete' not found"
        exit 1
    fi    
} 

main (){
    delete_user
}

main

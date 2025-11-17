#!/usr/bin/env bash

####################
# Author: Alexandre St-fort
# Last modified: 11/16/25
#####################


filedata=(
    "data.csv"
)

usercount=0

while IFS=: read -r name id desc; do
    echo ""
    echo "name: $name"
    echo "description: $desc"
    echo "id: $id"
    ((usercount++))
    echo "user: $usercount"
    echo ""
done < $filedata
printf "search all user:`date +"%A, %B %d, %Y - %H:%M"`:FROM see all users\n" >> command-history.csv
echo "$usercount users registered"
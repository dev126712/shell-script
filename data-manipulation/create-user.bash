#!/usr/bin/env bash

####################
# Author: Alexandre St-fort
# Last modified: 11/16/25
#
####################


FILE_DATA=$1

echo "User name to add: "
read user_name
echo "User id: "
read user_id
echo "Description: " 
read user_description

printf "$user_name:$user_id:$user_description`date +"%A, %B %d, %Y - %H:%M"`:user created FROM create user\n" >> command-history.csv

newuser="$user_name:$user_id:$user_description"
printf "$newuser\n" >> $FILE_DATA

echo "User added"

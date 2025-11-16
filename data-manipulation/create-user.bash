#!/usr/bin/env bash

####################
# Author: Alexandre St-fort
# Last modified: 11/16/25
#
####################


userlog="$1"

echo "User name to add: "
read user_name
echo "User id: "
read user_id
echo "Description: " 
read user_description

newuser="$user_name:$user_id:$user_description"
printf "$newuser\n" >> $userlog
echo "User added"

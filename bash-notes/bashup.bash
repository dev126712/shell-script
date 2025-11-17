#!/usr/bin/env bash

#user='aws sts get-caller-identity'
#useridentity=`$user | awk '{print $2}'`

useridentity=`aws sts get-caller-identity | awk '{print $2}'`

for u in $useridentity; do
    echo $u
done

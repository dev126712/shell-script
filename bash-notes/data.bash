#!/usr/bin/env bash

####################
# Author: Alexandre St-fort
# Last modified: 11/11/25
#
####################


#filedata=(
#    "data-search.bash"
#)

while IFS=: read -r name id desc; do
    echo ""
    echo "name: $name"
    echo "description: $desc"
    echo "id: $id"
    echo ""


done < $filedata

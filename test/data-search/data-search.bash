#!/usr/bin/env bash

filedata=(
    "data.txt"
)

while IFS=: read -r name id desc; do
    echo ""
    echo "name: $name"
    echo "description: $desc"
    echo "id: $id"
    echo ""


done < $filedata
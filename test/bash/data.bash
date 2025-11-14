#!/usr/bin/env bash


while IFS=: read -r name id desc; do
    echo ""
    echo "name: $name"
    echo "description: $desc"
    echo "id: $id"
    echo ""


done < data.txt
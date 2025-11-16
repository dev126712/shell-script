#!/usr/bin/env bash

count=0
for arg in "$@"; do
    echo "$count: <$arg>"
    ((count++))
done
echo "found: $count arguments" 
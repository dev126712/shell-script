#!/usr/bin/env bash

for arg in "$@"; do
    count=0
  # ls -la $arg
    for files in $arg/*; do
        ((count++))
        echo "$count: $files"
    done
done
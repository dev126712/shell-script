#!/usr/bin/env bash

for f in ../../*; do
    echo file is $f
done

for f in /usr/bin/*; do
  # echo file is $f
    if [ $f == "/usr/bin/bash" ]; then
        echo $f
        echo "yessss"
        sudo apt update
    fi
done
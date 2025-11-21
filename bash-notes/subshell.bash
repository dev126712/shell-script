#!/usr/bin/env bash

unset x; 
( x=hello; echo $x; ); 
echo $x

echo "----------------"

unset x; 
{ x=hello; echo $x; }; 
echo $x

echo "----------------"
echo "----------------"


echo b; echo a | sort

echo "----------------"

(echo b; echo a) | sort

echo "$(echo "$(echo "$(echo "$( ps wwf -s $$ )")")")"

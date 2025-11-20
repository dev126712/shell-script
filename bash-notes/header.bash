#!/usr/bin/env bash

# NR==1 the first line of the file "header"
# {print ($0)} = all the line
# {print ($1)} = first charachter until space or line breaker

set -x
# take the first line and make evyry character lowercase. 
awk 'NR==1{print tolower($0)}' people-1000.csv >> list.csv

# take the first line and make evyry character uppercase
awk 'NR==1{print toupper($0)}' people-1000.csv >> list.csv

# take the first line and make evyry character lowercase
awk 'NR==1{print length($0)}' people-1000.csv

# print the lenght of every line
awk '{print length($0)}' people-1000.csv 


# replace every " " by "-"
sed -zi 's/ /-/g;' people-1000.csv 

# replace every "-" by " "
sed -zi 's/-/ /g;' people-1000.csv >> list.csv

# replace every "," by ":"
sed -zi 's/,/:/g;' people-1000.csv
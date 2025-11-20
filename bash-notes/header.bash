#!/usr/bin/env bash

awk 'NR==1{print tolower($0)}' people-1000.csv >> list.csv
awk 'NR==1{print toupper($0)}' people-1000.csv >> list.csv
awk 'NR==1{print length($0)}' people-1000.csv
awk '{print length($0)}' people-1000.csv 


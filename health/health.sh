#!/usr/bin/env bash

####################
# Author: Alexandre St-fort
# Last modified: 11/11/25
#
# This script outputs the health machine
####################

#set -x

echo "Disk Space: "
df -h
echo ""

echo "Memory Usage: "
free -g
echo ""

echo "CPU Resources: "
nproc
echo ""

echo "Processes: "
ps -ef
echo ""

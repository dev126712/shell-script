#!/usr/bin/env bash

#for (( i=0; i<5; i++ )); do
#    echo $i
#done

#[[ -t 0 ]] < /etc/os-release

#[[ -t 0 ]]

#select choice in one two "three four"
#do
#    echo "$REPLY : $choice"
#done

#!/bin/bash

# --- Check if standard output (FD 1) is a terminal ---
if [[ -t 1 ]]; then
    # Standard output IS a terminal (e.g., the user is viewing the output directly)
    
    # Define ANSI color codes
    GREEN='\033[0;32m'
    NC='\033[0m' # No Color

    echo -e "${GREEN}✅ Running in interactive mode (Terminal detected).${NC}"
    echo "This output is human-readable and colored."
    # ... then proceed with interactive/colored output logic ...

else
    # Standard output is NOT a terminal (e.g., output is redirected to a file or piped)
    
    echo "❌ Running in non-interactive mode (Terminal not detected)."
    echo "This output is plain, suitable for files or pipes."
    # ... then proceed with machine-readable/plain output logic ...
fi > a.txt


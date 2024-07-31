#!/bin/bash 

ADRESSE="https://etudier.uqam.ca/cours?sigle="

# validation simple 
if [ $# -ne 1 ]; then 
    echo "le programme necessite 1 argument en parametre" 2>&1
    exit 1
fi

curl -s "$ADRESSE$1" | grep -oE "[A-Z]{2}-[A-Z]?[0-9]{3,4}"

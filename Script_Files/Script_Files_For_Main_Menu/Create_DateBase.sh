#!/bin/bash

#=======================================================================================#
#			     Create Database Code 		   	                                 #   #=======================================================================================#

# Color Codes
Blue='\033[1;34m'     # Blue color code
RED='\033[1;31m'      # Red color code
Green='\033[1;32m'    # Green color code
NC='\033[0m'           # No Color

echo -e "${NC}Please Enter Your Database Name : ${Blue}\c${NC}"
read DBname

# Validate the input using a regular expression
if [[ ! "$DBname" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
    echo -e "${RED}Invalid Database Name. Database names must start with a letter or underscore and contain only letters, numbers, and underscores.${NC}"
elif [ -d "./Databases/$DBname" ]; then               # to check if the given variable to exist Directory or not
    echo -e "${RED}This Database Already Exists.${NC}"
else
    mkdir "./Databases/$DBname" 2>> ../../.error.log  # to create Directory and set error in .error.log 
    if [ $? -eq 0 ]; then                             # to check the last commande is run by the correct way                       
        echo -e "${Blue}$DBname ${Green}Created Successfully.${NC}"
    else
        echo -e "${RED}An Error Occurred While Creating the Database.${NC}"
    fi
fi

./Main_Menu.sh   #return to the main menu           


#! /bin/bash
#=======================================================================================#
#			   List Databases	code 	   	     		                       #
#=======================================================================================#

# Define color codes for text formatting
Yellow='\033[1;33m'  # Yellow
Purple='\033[0;35m' #Purple
NC='\033[0m' 		# No Color
Cyan='\033[0;36m'  # Cyan

# List all available databases in the Databases directory
echo -e "${Yellow}Your All Databases Are: ${Cyan}"
ls ./Databases


# Return to the main menu
./Main_Menu.sh

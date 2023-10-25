#!/bin/bash

#================================================================#
#	                List Tables Code	                    #
#================================================================#

# Color Codes
Black='\033[1;30m' #Black
Orange='\033[0;33m' #Brown_Orange
Blue='\033[0;34m' #Blue
Purple='\033[0;35m' #Purple
Light_Blue='\033[0;34m' #Light_Blue
Cyan='\033[0;36m'  # Cyan
Yellow='\033[1;33m'  # Yellow
Red='\033[0;31m'    # Red
Light_Red='\033[1;31m' # Light_Red
Green='\033[0;32m'  # Green
Light_Green='\033[1;32m'  # Light_Green
NC='\033[0m'         # No Color

# Accept the current database name as an argument
currentDB="$1"

if [ `ls ./Databases/$currentDB -l | wc -l`  -gt 1 ];	# Greater than , wc -l  prints the line count
	then 
         	echo -e "${Yellow}Your Tables Are : ${Light_Blue}"
         	ls ./Databases/$currentDB
      	else
         	echo -e "${Yellow}Theie is Not Table to Show${NC}" 
fi


Script_Files/Script_Files_For_Main_Menu/Connect_To_Database.sh "$currentDB"   #return to Connect_To_Database 

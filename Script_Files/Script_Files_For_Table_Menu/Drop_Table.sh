#!/bin/bash

#=======================================================================================#
#			     Drop Table Code 		   	                #   #=======================================================================================#

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

echo -e "${NC}Enter your Table Name You want to Drop : ${Light_Blue}\c${NC}"
read Table_Name

#-------------- check if table is exist----------------------#
if [[ -f "./Databases/$currentDB/$Table_Name" ]]
	 then
		rm  ./Databases/$currentDB/$Table_Name            # to Drop this Table  
	  	echo -e "${Yellow}$Table_Name is Dorped Now Successfully${NC}"
  	                        
#-------------- if table is Not exist----------------------#	  	
else
		 echo -e "${Light_Red}$Table_Name is already Not exist ${NC}"

fi

Script_Files/Script_Files_For_Main_Menu/Connect_To_Database.sh "$currentDB"   #return to Connect_To_Database 

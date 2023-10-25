#!/bin/bash

#================================================================#
#	            Table Options Menu  Code	                    #
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

# Display the currently connected database:
echo -e "          ${Yellow}Connected to Database:${Purple} ${currentDB}${NC}"

# Define a function called connectToDB
function connectToDB
{
    # Display the Table menu
    echo -e "    ${Light_Green}+======================================+"
    echo -e "    |          Table Options Menu          |"
    echo -e "    |======================================|"
    echo -e "    |    1. Create Table                   |"
    echo -e "    |    2. List Tables                    |"
    echo -e "    |    3. Drop Table                     |"
    echo -e "    |    4. Insert into Table              |"
    echo -e "    |    5. Select from Table              |"
    echo -e "    |    6. Delete from Table              |"
    echo -e "    |    7. Update Table                   |"
    echo -e "    |    8. Main Menu                      |"
    echo -e "    |    9. Exit                           |"
    echo -e "    +======================================+${NC}"

    # Prompt the user for their choice
    echo -e "${NC}Enter Your Choice : ${Light_Blue}\c${NC}" #\c to get user input in the same line
    read Choice

    # Process user's choice
    case $Choice in 
        1) Script_Files/Script_Files_For_Table_Menu/Create_Table.sh "$currentDB";;
        2) Script_Files/Script_Files_For_Table_Menu/List_Table.sh "$currentDB";;
        3) Script_Files/Script_Files_For_Table_Menu/Drop_Table.sh "$currentDB";;
        4) Script_Files/Script_Files_For_Table_Menu/Insert_Into_Table.sh "$currentDB";;
        5) Script_Files/Script_Files_For_Table_Menu/Select_From_Table.sh "$currentDB";;
        6) Script_Files/Script_Files_For_Table_Menu/Delete_From_Table.sh "$currentDB";;
        7) Script_Files/Script_Files_For_Table_Menu/Update_Table.sh "$currentDB";;
        8) ./Main_Menu.sh;;  # Return to the main menu
        9) echo -e "${Yellow}Good Bye${NC}"; exit;; # Exit from the database
        *) echo -e "${Light_Red}Invalid Choice, try again ... you must choose only from the list${NC}"; connectToDB ;; # Call the function again
    esac
}

# Call the connectToDB function to start the database interaction
connectToDB


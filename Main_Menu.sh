#!/bin/bash

# Main Menu
#---------------------------------------------------------
# Color Codes
Light_Blue='\033[0;34m' #Light_Blue
Cyan='\033[0;36m'  # Cyan
Yellow='\033[1;33m'  # Yellow
Red='\033[0;31m'    # Red
Light_Red='\033[1;31m' # Light_Red
Green='\033[0;32m'  # Green
Light_Green='\033[1;32m'  # Light_Green
NC='\033[0m'         # No Color

# Print welcome message in Yellow
echo -e "${Yellow}Welcome to My Database Management System${NC}"

# Create DBMS directory if it doesn't exist and log errors
mkdir -p Databases 2>> ./.error.log

# Main Menu Function
function mainMenu {
    # Print Main Menu in Light_Green
    echo -e "${Light_Green}+--------------------------------------+"
    echo -e "|           Main Menu                  |"
    echo -e "+--------------------------------------+"
    echo -e "|  1. Create Database                  |"
    echo -e "|  2. List Databases                   |"
    echo -e "|  3. Connect To Database              |"
    echo -e "|  4. Drop Database                    |"
    echo -e "|  5. Exit                             |"
    echo -e "+--------------------------------------+${NC}"
    echo -e "${NC}Enter Your Choice :${Light_Blue} \c${NC}" #\c to get user input in the same line

    # Read user input
    read userChoice

    case $userChoice in 
        1) Script_Files/Script_Files_For_Main_Menu/Create_DateBase.sh;;
        2) Script_Files/Script_Files_For_Main_Menu/List_DateBases.sh;;
        3) 
            # Prompt the user for the database name
            echo -e "${Cyan}Enter the Name of the Database to Connect to:${NC} \c${NC}"
            read DB_Name
 		# Check if the database name contains only alphanumeric characters
		if [[ "$DB_Name" =~ ^[a-zA-Z0-9_]+$ ]]; then
            if [ -d ./Databases/$DB_Name ]; then
                # Set the current database variable
                currentDB="$DB_Name"

                # Open Connect_To_Database.sh and pass the current database variable
                Script_Files/Script_Files_For_Main_Menu/Connect_To_Database.sh "$currentDB"
            else
                echo -e "${Light_Red}Database '$DB_Name' Does Not Exist.${NC}"
                # Call the main menu function
                mainMenu
            fi
          else
        		echo -e "${Light_Red}Invalid database name. Please use only alphanumeric characters and underscores.${NC}"
        		 # Call the main menu function
                mainMenu
    		fi
            
            ;;
        4) Script_Files/Script_Files_For_Main_Menu/Drop_Database.sh;;
        5) echo -e "${Yellow}Good Bye${NC}"; exit;;
        *) echo -e "${Light_Red}Invalid Choice, Please Try Again.${NC}"; mainMenu
    esac
}

# Call the main menu function
mainMenu


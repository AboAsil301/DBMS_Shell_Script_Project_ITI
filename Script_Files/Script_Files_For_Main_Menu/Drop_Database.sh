#! /bin/bash

#=======================================================================================#
#		                    Drop Database Code  		   	       #
#=======================================================================================#

# Define color codes for text formatting
Yellow='\033[1;33m'	# Yellow color code
Blue='\033[1;34m'	# Blue color code 
RED='\033[1;31m'	# Red color code 
Green='\033[1;32m'	# Green color code
NC='\033[0m' 		# No Color (reset)

# List all available databases in the Databases directory
echo -e "${NC}Your All Databases Are: "
ls ./Databases

# Ask the user to enter the name of the database to delete
echo -e "${NC}Please Enter the Name of the Database to Delete: ${Blue}\c${NC}"
read DB_Name

# Check if the specified database directory exists
if [ -d ./Databases/$DB_Name ]; then

    # Prompt the user for confirmation with 'y' or 'n'
    echo -e "${RED}Are You Sure of Your Choice to Drop This Database?${NC} Choose ${RED}[y${NC}/${RED}n]${NC}: ${Blue}\c${NC}"
    read choice

    # Use a case statement to handle user choice
    case $choice in
        [Yy] )  
            # If the user chooses 'y', delete the database directory
            rm -r "./Databases/$DB_Name"
            echo -e "${NC}$DB_Name ${Green}Has Been Dropped Successfully${NC}";;
        [Nn] ) 
            # If the user chooses 'n', cancel the drop operation
            echo -e "${Yellow}Drop ${NC}$DB_Name ${Yellow}Has Been Cancelled${NC}";;
        * ) 
            # If the user enters an invalid choice, inform them that it's invalid
            echo -e "${NC}$DB_Name ${RED}Is an Invalid Choice${NC}";;
    esac
else
    # If the specified database directory does not exist, inform the user
    echo -e "${RED}Database '$DB_Name' Does Not Exist.${NC}"
fi

# Return to the main menu
./Main_Menu.sh


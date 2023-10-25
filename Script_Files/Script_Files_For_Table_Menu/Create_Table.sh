#!/bin/bash

#===================================================================================#
#                        Create Table Code                                          #
#===================================================================================#

# Color Codes
Purple='\033[0;35m'      # Purple
Light_Blue='\033[0;34m'  # Light_Blue
Cyan='\033[0;36m'        # Cyan
Yellow='\033[1;33m'      # Yellow
Red='\033[0;31m'         # Red
Light_Red='\033[1;31m'   # Light_Red
Green='\033[0;32m'       # Green
Light_Green='\033[1;32m' # Light_Green
NC='\033[0m'             # No Color

# Accept the current database name as an argument
currentDB="$1"

# Prompt for the table name
echo -e "${NC}Please Enter Your Table Name: ${Light_Blue}\c${NC}"
read Table_Name


while true; do

# Validate the table name using a regular expression
if [[ ! "$Table_Name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
    echo -e "${Light_Red}Invalid Table Name. Table names must start with a letter or underscore and contain only letters, numbers, and underscores.${NC}"
    
    break
fi

# Check if the table already exists
if [ -f "./Databases/$currentDB/$Table_Name" ]; then
    echo -e "${Light_Red}This Table Already Exists.${NC}"
    
    break
else
    # Prompt the user for the number of columns
    while true; do
        echo -e "${NC}Enter the Number of Columns (1-15): ${Light_Blue}\c${NC}"
        read colNum

        # Check if the input is a valid positive integer between 1 and 15
        if [[ $colNum =~ ^[1-9][0-4]?$ || $colNum == 15 ]]; then
            break  # Valid input, exit the loop
        else
            echo -e "${Light_Red}Please enter a valid number between 1 and 15.${NC}"
        fi
    done

    if [ $? -eq 0 ]; then
        i=1
        separator=","

        # Initialize metadata as an empty string
        metadata=""

        # Array to store column names to check for uniqueness
        declare -a columnNames

        while [ $i -le $colNum ]; do
            # Get the column name and validate it
            while true; do
                echo -e "${NC}Enter Name of column Number $i: ${Light_Blue}\c${NC}"
                read colName

                # Check if the column name is valid
                if [[ $colName =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
                    # Check if the column name is unique within the table
                    if [[ " ${columnNames[@]} " =~ " ${colName} " ]]; then
                        echo -e "${Light_Red}Column name '$colName' is not unique. Please enter a unique name.${NC}"
                    else
                        columnNames+=("$colName")
                        break  # Valid column name, exit the loop
                    fi
                else
                    echo -e "${Light_Red}Invalid column name. Column name must start with a letter or _ and contain only letters, numbers, and underscores.${NC}"
                fi
            done

            # Get the data type for the column
            while true; do
                # Print data type Menu in Light_Green
                echo -e "${Light_Green}+--------------------------------------+"
                echo -e "|             data type Menu           |"
                echo -e "+--------------------------------------+"
                echo -e "|  1. int                              |"
                echo -e "|  2. string                           |"
                echo -e "+--------------------------------------+${NC}"
                echo -e "${Cyan}Enter Your Choice:${NC} \c${NC}" #\c to get user input in the same line

                # Read user input
                read userChoice

                case $userChoice in
                    1)
                        colType="int"
                        break
                        ;;
                    2)
                        colType="string"
                        break
                        ;;
                    *)
                        echo -e "${Light_Red}Invalid choice. Please select a valid data type.${NC}"
                        ;;
                esac
            done

            # Ask if the column should be a primary key
            while true; do
                echo -e "Do you want to make it a primary key? [y/n]: \c"
                read choice
                case $choice in
                    [Yy])
                        pkey="Pk"
                        ;;
                    [Nn])
                        pkey=""
                        ;;
                    *)
                        echo -e "${Light_Red}Invalid choice. Please enter 'y' for yes or 'n' for no.${NC}"
                        continue
                        ;;
                esac

                # Append column information to metadata
                metadata+="$colName%$colType%$pkey$separator"

                break
            done

            ((i=$i+1))  # Increase i by 1
        done

        # Remove trailing separator from metadata
        metadata=${metadata%,}

        # Create the table file and write metadata to it
        touch "./Databases/$currentDB/$Table_Name" 2>> ../../.error.log  # Create file and log errors
        echo "$metadata" >> "./Databases/$currentDB/$Table_Name" 2>> ./Databases/$currentDB/.error.log

        if [ $? -eq 0 ]; then
            echo -e "${Light_Green}Table :${Purple} ${Table_Name} ${Light_Green}created successfully.${NC}"
            break
        else
            echo -e "${Light_Red}An Error Occurred While Creating the Table.${NC}"
            break
        fi
    fi
fi
done
# Return to Connect_To_Database.sh
Script_Files/Script_Files_For_Main_Menu/Connect_To_Database.sh "$currentDB"


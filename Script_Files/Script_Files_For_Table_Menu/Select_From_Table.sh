#!/bin/bash

#================================================================#
#              Select from Table Code                            #
#================================================================#

# Define color codes for better output formatting
Black='\033[1;30m'       # Black
Orange='\033[0;33m'      # Brown_Orange
Blue='\033[0;34m'        # Blue
Purple='\033[0;35m'      # Purple
Light_Blue='\033[0;34m'  # Light_Blue
Cyan='\033[0;36m'        # Cyan
Yellow='\033[1;33m'      # Yellow
Red='\033[0;31m'         # Red
Light_Red='\033[1;31m'   # Light_Red
Green='\033[0;32m'       # Green
Light_Green='\033[1;32m' # Light_Green
NC='\033[0m'             # No Color

# Function to check if a table exists
table_exists() {
    local db="$1"
    local table="$2"
    if [[ -f "./Databases/$db/$table" ]]; then
        return 0  # Table exists
    else
        return 1  # Table does not exist
    fi
}

# Accept the current database name as an argument
currentDB="$1"

echo -e "${NC}Enter the name of the table you want to delete from: ${Light_Blue}\c${NC}"
read Table_Name

# Check if the table exists
if table_exists "$currentDB" "$Table_Name"; then
    while true; do
        # Present the user with options for deletion
        echo -e "${Light_Green}+--------------------------------------+"
        echo -e "|       Options for Select Menu      |"
        echo -e "+--------------------------------------+"
        echo -e "|  1. Select all table data            |"
        echo -e "|  2. Select specific row(s)           |"
        echo -e "+--------------------------------------+${NC}"
        echo -e "${Light_Blue}Enter Your Choice: \c${NC}"

        # Read user input
        read userChoice

        case $userChoice in
            1)
                # Select all data except for the first line (column names)
                echo -e "${Yellow}Selected data for all rows except column names:${NC}"
                tail -n +2 "./Databases/$currentDB/$Table_Name"
                echo -e "${Light_Green}All data Selected except for column names.${NC}"
                break
                ;;
            2)
                # Present the table columns as a menu
                table_metadata=$(head -n 1 "./Databases/$currentDB/$Table_Name")
                IFS=',' read -ra column_metadata <<< "$table_metadata"
                coloumnsCount=${#column_metadata[@]}
                column_menu="|"

                # Prompt the user to enter data for each column
                for ((i = 0; i < $coloumnsCount; i++)); do
                    IFS='%' read -ra col_info <<< "${column_metadata[$i]}"
                    col_name="${col_info[0]}"
                    col_type="${col_info[1]}"
                    col_primary="${col_info[2]}"
                    column_menu+=" ${col_name} (${col_type}) |"
                done

                # Display table columns
                echo -e "${Yellow}Columns in $Table_Name:${NC}"
                echo -e "${Yellow}${column_menu}${Light_Blue}"

                while true; do
                    # Prompt the user for the field name to search in
                    read -p "Enter the field name you want to search in: " field

                    # Check if the entered field name exists in the table metadata
                    if [[ "$table_metadata" == *"$field"* ]]; then
                        # Prompt the user for the field value to search for
                        read -p "Enter the field value you want to search for: " value
                        table="./Databases/$currentDB/$Table_Name"

                        # Find the field number (NF) by searching for the field name in the metadata
                        NF=$(awk -F ',' -v pat="$field" '{split($0, fields, "%"); for (i=1; i<=NF; i++) { if (fields[i] == pat) { print i } }}' "$table")

                        # Find the row number (NR) where the value matches
                        NR=$(awk -F ',' -v pat="$value" -v field="$NF" '$field == pat { print NR }' "$table")

                        # Check if the row number (NR) is empty; if so, the value was not found
                        if [[ -z "$NR" ]]; then
                            echo -e "${Red}Value Not Found${NC}"
                            break 2
                        else
                            # Select the row(s) with the specified row number (NR)
                            echo -e "${Yellow}Selected data for row(s) where $field = $value:${NC}"
                            awk -F ',' -v pat="$value" -v field="$NF" '$field == pat { print $0 }' "$table"
                            echo -e "${Light_Green}Row(s) Selected Successfully${NC}"
                            break 2
                        fi
                    else
                        echo -e "${Red}Invalid field name. Please enter a valid field name.${NC}"
                    fi
                done
                ;;
            *)
                echo -e "${Red}Invalid choice. Please select a valid option for deletion.${NC}"
                ;;
        esac
    done
else
    echo -e "${Red}Table $Table_Name does not exist.${NC}"
fi

# Return to the Connect_To_Database script
Script_Files/Script_Files_For_Main_Menu/Connect_To_Database.sh "$currentDB"


#!/bin/bash

#================================================================#
#                 Update Table Code	                         #
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

# Function to test data type
test_data_type() {
    local var="$1"
    local result=""

    # Check if the variable is empty
    if [ -z "$var" ]; then
        result="Variable is empty."
    else
        # Use a pattern to check for alphabetic characters (string)
        if [[ "$var" =~ [A-Za-z] ]]; then
            result="string"
        fi

        # Use a pattern to check for digits (integer)
        if [[ "$var" =~ ^[0-9]+$ ]]; then
            result="int"
        fi

        # Use a pattern to check for a floating-point number
        if [[ "$var" =~ ^[0-9]+\.[0-9]+$ ]]; then
            result="floating-point number"
        fi
    fi

    # Return the result
    echo "$result"
}

# Accept the current database name as an argument
currentDB="$1"

echo -e "${NC}Enter the name of the table you want to Update from: ${Light_Blue}\c${NC}"
read Table_Name

# Check if the table exists
if table_exists "$currentDB" "$Table_Name"; then
    # Present the table columns as a menu
    table_metadata=$(head -n 1 "./Databases/$currentDB/$Table_Name")
    IFS=',' read -ra column_metadata <<< "$table_metadata"
    coloumnsCount=${#column_metadata[@]}     # Get the number of columns
    column_menu=""

    # Prompt the user to enter data for each column
    for ((i = 0; i < $coloumnsCount; i++)); do
        IFS='%' read -ra col_info <<< "${column_metadata[$i]}"
        col_name="${col_info[0]}"
        col_type="${col_info[1]}"
        col_primary="${col_info[2]}"
        column_menu+="		$((i + 1))  ==> ${col_name} (${col_type}) ${col_primary}\n"

    done

    # Display table columns
    echo -e "${Yellow}Columns in $Table_Name:${NC}"
    echo -e "${Yellow}${column_menu}${NC}"

    while true; do
        # Prompt the user for the field number to search in
        read -p "Enter the field Number you want to search in: " colNum

        # Check if the entered field number exists in the columns menu
        if [[ $((colNum - 1)) -ge 0 && $((colNum - 1)) -le $coloumnsCount ]]; then
            # Prompt the user for the field value to search for
            read -p "Enter the field value you want to search for: " value
		# -----Test Data Type of newValue  ---------------------------#
		while true; do
            # Prompt the user for the field New value
            read -p "Enter the field New value : " newValue
             # Check if the New value is valid
            if [[ $newValue =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
            
            IFS='%' read -ra col_info <<< "${column_metadata[(colNum - 1)]}"
        			col_name="${col_info[0]}"
        			col_type="${col_info[1]}"
        			col_primary="${col_info[2]}"
					if [[ "$col_type" == "$(test_data_type "$newValue")" ]]; then
                        
                        		break
                        	else
                        		echo -e "${Light_Red}Data Type of newValue must is ${col_type} ${NC}"
                        	fi
                        	 break
            
            else
                    echo -e "${Light_Red}Invalid newValue. newValue  must start with a letter or _ and contain only letters, numbers, and underscores.${NC}"
            fi
             
          done              	

            table="./Databases/$currentDB/$Table_Name"
            
            # -----------------------Check Pk----------------------------#
            if testPk=$(awk -F ',' -v colNum="$colNum" 'NR==1 {if ($colNum ~ /%Pk%/){print $colNum}}' "$table"); then
                # ------------Check duplication data----------------------------#
                if checkNewValue=$(cut -f$colNum -d, "$table" | grep -w "$newValue"); then
                    echo -e "${Light_Red}This value already exists${NC}"
				break
                fi
 
            fi
            
		  # -------------------Proceed with the update-----------------------#

            # Update the row with the new value
            awk -F, -v colNum="$colNum" -v newValue="$newValue" -v value="$value" 'BEGIN{OFS=","} NR>1 && $colNum == value 				{$colNum=newValue} {print}' "$table" > tempFile
            mv tempFile "$table"
            echo -e "${Yellow}Your data was updated successfully${NC}"
            break
        else
            echo -e "${Light_Red}Invalid field number. Please enter a valid field number${NC}"
        fi
    done
else
    echo -e "${Light_Red}Table $Table_Name does not exist${NC}"
fi

Script_Files/Script_Files_For_Main_Menu/Connect_To_Database.sh "$currentDB"   # Return to Connect_To_Database


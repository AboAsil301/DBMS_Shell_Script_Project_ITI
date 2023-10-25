#!/bin/bash

#================================================================#
#	             Insert Into Table Code	                    #
#================================================================#

# Define color codes for terminal text
Black='\033[1;30m'     
Orange='\033[0;33m'    
Blue='\033[0;34m'      
Purple='\033[0;35m'    
Light_Blue='\033[0;34m' 
Cyan='\033[0;36m'      
Yellow='\033[1;33m'    
Red='\033[0;31m'       
Light_Red='\033[1;31m' 
Green='\033[0;32m'     
Light_Green='\033[1;32m'
NC='\033[0m'

# Function to validate integer input
validate_integer() {
    local data_value="$1"
    if [[ "$data_value" =~ ^[0-9]+$ ]]; then
        return 0  # Valid integer
    else
        return 1  # Invalid input
    fi
}

# Function to validate string input without symbols
validate_string() {
    local data_value="$1"
    if [[ "$data_value" =~ ^[A-Za-z\s]+$ ]]; then
        return 0  # Valid string
    else
        return 1  # Invalid input
    fi
}


# Function to check for duplicate data in the column
check_duplicate_data() {
    local data_value="$1"
    local col_name="$2"
    local table_name="$3"
    
    # Read the entire column to check for duplicates
    if grep -q "^$data_value," "./Databases/$currentDB/$table_name"; then
        return 0  # Data is not unique
    else
        return 1  # Data is unique
    fi
}

# Accept the current database name as an argument
currentDB="$1"

# Prompt the user to enter the table name they want to insert data into
echo -e "${Light_Blue}Which table you want to insert into: ${NC}\c${NC}"
read Table_Name

# Check if the table exists
if [[ -f "./Databases/$currentDB/$Table_Name" ]]; then
    # Read the column names and types from the first line of the table file
    table_metadata=$(head -n 1 "./Databases/$currentDB/$Table_Name")

    # Split the metadata into an array based on the comma (,) delimiter
    IFS=',' read -ra column_metadata <<< "$table_metadata"

    # Determine the number of columns
    coloumnsCount=${#column_metadata[@]}

    # Initialize an array to store column data
    declare -a column_data

    # Prompt the user to enter data for each column
    for ((i = 0; i < $coloumnsCount; i++)); do
        # Extract column name, data type, and primary key status
        IFS='%' read -ra col_info <<< "${column_metadata[$i]}"
        col_name="${col_info[0]}"
        col_type="${col_info[1]}"
        col_primary="${col_info[2]}"

        while true; do
            # Prompt the user for data value for the current column
            echo -e "${Light_Blue}Enter data for column '$col_name' ($col_type):${NC} \c${NC}"
            read data_value

            # Validate and sanitize data based on data type
            if [[ "$col_type" == "int" ]]; then
                validate_integer "$data_value"
                if [[ $? -eq 0 ]]; then
                    # Check for duplicate data if it's a primary key
                    if [[ "$col_primary" == "Pk" ]]; then
                        check_duplicate_data "$data_value" "$col_name" "$Table_Name"
                        if [[ $? -eq 0 ]]; then
                            echo -e "${Light_Red}Data value '$data_value' already exists in the column '$col_name'. Please enter a unique value.${NC}"
                            continue
                        fi
                    fi
                    # Data is valid, and the column is not a primary key or data is unique
                    column_data[$i]="$data_value"
                    break
                else
                    echo -e "${Light_Red}Invalid input! Please enter a valid integer.${NC}"
                fi
            elif [[ "$col_type" == "string" ]]; then
                validate_string "$data_value"
                if [[ $? -eq 0 ]]; then
                    # Check for duplicate data if it's a primary key
                    if [[ "$col_primary" == "Pk" ]]; then
                        check_duplicate_data "$data_value" "$col_name" "$Table_Name"
                        if [[ $? -eq 0 ]]; then
                            echo -e "${Light_Red}Data value '$data_value' already exists in the column '$col_name'. Please enter a unique value.${NC}"
                            continue
                        fi
                    fi
                    # Data is valid, and the column is not a primary key or data is unique
                    column_data[$i]="$data_value"
                    break
                else
                    echo -e "${Light_Red}Invalid input! Please enter a string without symbols.${NC}"
                fi
            else
                echo -e "${Light_Red}Unsupported data type: $col_type. Cannot insert data.${NC}"
            fi
        done
    done

    # Join the column data into a comma-separated string
    row_data=$(IFS=','; echo "${column_data[*]}")

    # Append the row data to the table file
    echo "$row_data" >> "./Databases/$currentDB/$Table_Name"

    # Inform the user that data has been successfully inserted
    echo -e "${Light_Green}Data inserted successfully.${NC}"
else
    echo -e "${Light_Red}Table $Table_Name does not exist ${NC}"
fi

# Return to Connect_To_Database script
Script_Files/Script_Files_For_Main_Menu/Connect_To_Database.sh "$currentDB"


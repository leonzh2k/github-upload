#!/usr/bin/bash

# The only command line argument is a file name
file_name=$1
# passed bool value, will be false if any check fails
passed=true
# echo "parsing $1"
# Iterate over each line of the input file
while IFS= read -r line; do
    # Here's where you can use regex capture groups to extract the info from each line
    # You'll need to capture two pieces of data: the field name and the value of the field.
    # Put your regex with capture groups to the right of the =~ operator
    if [[ $line =~  ^[[:space:]]*(.*):[[:space:]]*(.*)$ ]]; then #:[[:space:]]{,1}(.*)
        # Recall how to access text from regex capture groups
        # See slide 15 from the lecture
        field=${BASH_REMATCH[1]}
        value=${BASH_REMATCH[2]}
        # echo "FIELD: $field"
        # echo "VALUE: $value"
    else
        # If nothing could be extraced, then skip the line
        continue
    fi

    case $field in
        # You can follow this pattern for all other fields
        first_name) 
            # echo "CHECKING FIRST NAME"
            pattern='^[[:alpha:]]+$'
            ;;
        last_name) 
            # echo "CHECKING LAST NAME"
            pattern='^[[:alpha:]]+$'
            ;;
        phone_number) 
            # echo "CHECKING PHONE NUMBER"
            pattern='^([0-9]{3})-([0-9]{3})-([0-9]{4})$'
            ;;
        email) # Case where the field name is literally the string "email"
            # Same regex for email that we used in lecture
            # echo "CHECKING EMAIL"
            pattern='^[[:alnum:]_#-]+@[[:alnum:]-]+\.[[:alnum:]]{2,4}$'
            ;;
        street_number) 
            # echo "CHECKING STREET NUMBER"
            pattern='^[0-9]{1,5}$'
            ;;
        street_name) 
            # echo "CHECKING STREET NAME"
            pattern='^([[:alpha:]]|[[:space:]])+$'
            ;;
        apartment_number) 
            # echo "CHECKING APARTMENT NUMBER"
            pattern='(^[0-9]{1,4}$|^$)'
            ;;
        city) 
            # echo "CHECKING CITY"
            pattern='^([[:alpha:]]|[[:space:]])+$'
            ;;
        state) 
            # echo "CHECKING STATE"
            pattern='^[A-Z]{2}$'
            ;;
        zip) 
            # echo "CHECKING ZIP"
            pattern='^[0-9]{5}$'
            ;;    
        card_number) # Case where there the field name didn't match anything
            # echo "CHECKING CARD NUMBER"
            pattern='^[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{4}'
            ;;
        expiration_month) # Case where there the field name didn't match anything
            # echo "CHECKING EXPIRATION MONTH"
            pattern='(^0[1-9]$|^1[0-2]$)'
            ;;
        expiration_year) # Case where there the field name didn't match anything
            # echo "CHECKING EXPIRATION YEAR"
            pattern='^202[1-9]$'
            ;;
        ccv) # Case where there the field name didn't match anything
            # echo "CHECKING CCV"
            pattern='^[0-9]{3}$'
            ;;
        *) # Case where there the field name didn't match anything
            # echo "THIS FIELD NAME ISN'T SUPPOSED TO HAVE A VALUE"
            value='intentionally no value'
            pattern='^intentionally no value$'
            ;;
    esac


    if ! [[ $value =~ $pattern ]]; then
        # We need to print out a message if the field isn't valid
        echo "field $field with value $value is not valid"
        passed=false
    # else 
    #     echo "field $field with value $value is valid"
    fi
        
done < "$file_name"

# We need to print something if all fields were valid
# Remember, booleans are useful for this assignment
if [[ $passed = true ]]; then
    echo "purchase is valid"
    exit 0
fi

#!/bin/bash

# Get directory path from the user
read -p "Enter the directory path: " directory_path

# Convert Windows-style backslashes to Unix-style forward slashes using sed
directory_path=$(echo "$directory_path" | sed 's/\\/\//g')

# Get text from the user
read -p "Enter the text to search: " search_text

# Check if the provided path is a valid directory
if [ ! -d "$directory_path" ]; then
    echo "Error: The provided path is not a valid directory."
    exit 1
fi

# Function to search for text in files recursively
search_text_in_files() {
    local dir="$1"
    local text="$2"

    # Iterate through each file in the directory
    for file in "$dir"/*; do
        if [ -d "$file" ]; then
            # If it's a directory, recursively search its contents
            search_text_in_files "$file" "$text"
        elif [ -f "$file" ]; then
            # If it's a file, check if the text is present
            if grep -q "$text" "$file"; then
                echo "Text found in: $file"
            fi
        fi
    done
}

# Call the function with the provided directory and text
search_text_in_files "$directory_path" "$search_text"

# Check if text was not found
if [ $? -ne 0 ]; then
    echo "Text not found"
fi

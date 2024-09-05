#!/bin/bash

# Define log file
LOG_FILE="script.log"

# Function to log messages with timestamps
log_message() {
    local MESSAGE=$1
    local TYPE=$2
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$TYPE] - $MESSAGE" >> "$LOG_FILE"
}

# Initialize log file
> "$LOG_FILE"
log_message "Script started" "INFO"

# Check if CSV file is provided
if [ "$#" -ne 1 ]; then
    log_message "Usage: $0 <csv_file>" "ERROR"
    exit 1
fi

CSV_FILE="$1"

# Check if the provided CSV file exists
if [ ! -f "$CSV_FILE" ]; then
    log_message "CSV file not found: $CSV_FILE" "ERROR"
    exit 1
fi

# Initialize the array for directories
declare -a directories_and_files
# directories_and_files=("item1" "item2" "item3")

# Use a temporary file to store directories read from CSV
temp_file=$(mktemp)

# Read and process the CSV file using awk
awk -F, '
    $1 == "DIRECTORIES" {
        for (i = 2; i <= NF; i++) {
            gsub(/^"|"$/, "", $i)  # Remove leading and trailing double quotes
            gsub(/^[ \t]+|[ \t]+$/, "", $i)  # Trim leading/trailing spaces
            print $i
        }
    }
' "$CSV_FILE" > "$temp_file"




# Read the directories from the temporary file
while IFS= read -r dir; do
    # echo "Processing directory: '$dir'"  # Debugging output
    if [ -d "$dir" ]; then
        # echo "${directories_and_files[@]}"  # Debugging output
        # printf "%s," "${directories_and_files[@]}"  # Debugging output
        directories_and_files+=("$dir")
        log_message "Added directory to list: $dir" "INFO"
        # echo "Added directory: $dir"  # Debugging output
    else
        # echo "Directory does not exist: $dir ERROR"
        log_message "Directory does not exist: $dir" "ERROR"
    fi
done < "$temp_file"

# Clean up the temporary file
rm "$temp_file"

log_message "Finished processing CSV file" "INFO"

# Print the contents of directories_and_files for debugging
# echo "Final list of directories to back up:"
for dir in "${directories_and_files[@]}"; do
    echo "$dir"
    log_message "$dir" "INFO"
done

# Debug output to confirm array length
# echo "Number of directories found: ${#directories_and_files[@]}"
# echo "${#directories_and_files[@]}"

# Check if at least one valid directory was found
if [ "${#directories_and_files[@]}" -eq 0 ]; then
    log_message "No valid directories found to back up" "ERROR"
    exit 1
fi

# Optional: log the final list of valid directories
log_message "Directories to back up: ${directories_and_files[*]}" "INFO"

# Your backup script would follow here

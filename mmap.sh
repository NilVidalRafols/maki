#!/bin/bash
set -eo pipefail

# Check if at least 3 arguments are provided (command + output_dir + at least one file)
if [[ $# -lt 3 ]]; then
    echo "Usage: map 'command' output_dir file1 [file2 ...]" >&2
    exit 1
fi

# Store the command string and output directory
cmd="$1"
output_dir="$2"
output_dir="${output_dir%/}"
shift 2

# Create output directory if it doesn't exist
if [[ ! -d "$output_dir" ]]; then
    mkdir -p "$output_dir"
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to create output directory '$output_dir'" >&2
        exit 1
    fi
fi

# Iterate over each file argument
for file in "$@"; do
    # Check if file exists and is readable
    if [[ ! -f "$file" ]]; then
        echo "Error: '$file' is not a valid file" >&2
        continue
    fi
    
    if [[ ! -r "$file" ]]; then
        echo "Error: '$file' is not readable" >&2
        continue
    fi
    
    # Extract filename from path
    filename=$(basename "$file")
    
    # Create output filename with map_ prefix
    output_file="${output_dir}/map_${filename}"
    
    # Pass file content through stdin to the command and redirect to output file
    # read -r -a cmd <<< "$cmd"
    bash -c "$cmd" < "$file" > "$output_file"
    
    echo "Processed: $file -> $output_file"
done

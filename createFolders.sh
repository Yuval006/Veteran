#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <number_of_exercises>"
    exit 1
fi

# Retrieve the argument passed to the script, representing the number of exercises to create
num_of_exercises="$1"

# Loop through the range of exercise numbers, creating directories and script files
for num in $(seq 1 "$num_of_exercises"); do
    # Create a directory for each exercise using the format "Exresice_1", "Exresice_2", ...
    directory_name="Exercise_$num"
    mkdir "$directory_name"

    # Create a new script file inside the exercise directory, named "ex1.sh", "ex2.sh", ...
    script_file="$directory_name/ex$num.sh"
    touch "$script_file"

    # Make the script file executable, allowing it to be executed directly
    chmod +x "$script_file"
done

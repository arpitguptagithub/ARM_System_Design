#!/bin/bash

capture_name() {
    # Run the Python script and capture its output
    local output
    output=$(python vm/linker/VMLinker.py vm/linker/tests/vmcode1_new.vm vm/linker/tests/vmcode2_new.vm)
    
    # Extract the name (assuming the output format is "target_name name")
    local name
    name=$(echo "$output" | awk '{print $2}') # Get the second word
    
    echo "$name" # Return the captured name
}

# Call the function and store its result
name=$(capture_name)

# Print the captured name
echo "Captured name: $name"

python vm/Engine.py "$name"
asm_name="${name%.*}.asm"
python assembler/assembler.py "$asm_name"
python assembler/loader.py "$asm_name" asmout.obj

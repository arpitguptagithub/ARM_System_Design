import re

def process_code(file_path):
    # Read the content of the file
    with open(file_path, 'r') as file:
        input_code = file.read()

    # Step 1: Extract and store all segments between "label glob_init:" and "return_init \n end_init"
    pattern = r"label glob_init(.*?)return_init\s+end_init"
    stored_segments = re.findall(pattern, input_code, re.DOTALL)

    # Step 2: Remove all those segments from the code
    modified_code = re.sub(pattern, '', input_code, flags=re.DOTALL)

    # Step 3: Create the new segment with the stored inputs
    new_segment = "label glob_init\n"
    for segment in stored_segments:
        new_segment += segment.strip() + "\n"
    new_segment += "return_init\nend_init\n"

    # Step 4: Insert the new segment below "VM:"
    final_code = re.sub(r"(VM:)", r"\1\n" + new_segment, modified_code)

    # Write the processed content back to the file
    with open(file_path, 'w') as file:
        file.write(final_code)

# File path to process
file_path = "tac.txt"

# Call the function to process the file
process_code(file_path)

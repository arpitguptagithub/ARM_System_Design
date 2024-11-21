import re

# Open the input file (font_map.h) for reading
with open("font_old.h", "r") as input_file:
    # Read all the lines in the file
    lines = input_file.readlines()

# Prepare an output list for reversed decimal rows
decimal_rows = []

# Loop through lines to find the binary font maps
for line in lines:
    # Use regex to extract binary strings from the lines
    matches = re.findall(r'"([01]{8})"', line)
    if matches:  # If binary strings are found
        reversed_decimals = [
            str(int(row[::-1], 2)) for row in matches  # Reverse each binary string and convert to decimal
        ]
        decimal_rows.append(", ".join(reversed_decimals))

# Write the reversed decimal output to a new file
with open("font_new.h", "w") as output_file:
    output_file.write("int font_map[128][8] = {\n")
    for row in decimal_rows:
        output_file.write("{ "+row + " },\n")
    output_file.write("}")

print("Conversion complete! Output saved to font_map_reversed.dec")

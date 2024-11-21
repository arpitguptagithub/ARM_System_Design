import numpy as np

def visualize_binary_to_file(input_file, output_file):
    # Read the binary data from the file
    with open(input_file, 'r') as file:
        lines = file.readlines()

    # Ensure the file has 2400 lines of 32-bit binary strings
    if len(lines) != 2400:
        raise ValueError("The file must contain exactly 2400 lines of 32-bit binary data.")

    # Validate each line for length and binary content
    for line in lines:
        line = line.strip()
        if len(line) != 32 or not set(line).issubset({'0', '1'}):
            raise ValueError("Each line must contain exactly 32 bits of binary data (0s and 1s).")

    # Convert lines to a numpy array
    binary_data = np.array([[int(bit) for bit in line.strip()] for line in lines])

    # Group every 10 lines into rows by stacking them vertically
    rows = []
    for i in range(0, 2400, 10):  # Step through the lines in groups of 10
        # Combine the 10 lines vertically into one row
        combined_row = np.vstack(binary_data[i:i+10])
        rows.append(combined_row)

    # Stack all rows together to form the full display
    display_data = np.hstack(rows)

    # Write the combined display data into a text file
    with open(output_file, 'w') as out_file:
        for row in display_data:
            out_file.write(''.join(map(str, row)) + '\n')

    print(f"Display written to {output_file}")

# Example usage
input_file = "screen.txt"  # Replace with the path to your input file
output_file = "visualized_display.txt"  # Replace with the desired output file name
visualize_binary_to_file(input_file, output_file)

import matplotlib.pyplot as plt
import numpy as np

# Define display parameters
ROWS = 60
COLS = 80
FONT_HEIGHT = 8
FONT_WIDTH = 1  # Each character is represented as a column

# Create a blank display
display = np.zeros((ROWS * FONT_HEIGHT, COLS * FONT_WIDTH), dtype=np.uint8)

# Function to write a binary line on the display
def write_binary_line(display, binary_line, line):
    # Ensure binary line has exactly 8 bits and is within the column range
    if len(binary_line) == 8 and 0 <= line < ROWS:
        for col, bit in enumerate(binary_line):
            if col < COLS:  # Ensure we stay within column limits
                display[line * FONT_HEIGHT: (line + 1) * FONT_HEIGHT, col * FONT_WIDTH] = int(bit)

# Read memory from file and write to display
def load_memory_to_display(filename, start_line, end_line):
    with open(filename, 'r') as file:
        lines = file.readlines()
        for line_num in range(start_line, min(end_line, len(lines))):
            binary_line = lines[line_num].strip()  # Read and strip whitespace/newline
            write_binary_line(display, binary_line, line_num - start_line)

# Example: Load lines from 10 to 20
load_memory_to_display('../memory.txt', 10, 20)

# Display settings
plt.imshow(display, cmap='gray', interpolation='nearest')
plt.axis('off')  # Turn off axis numbers and ticks
plt.title('Display Output')
plt.savefig('display_output.jpg', bbox_inches='tight', pad_inches=0)  # Save the figure as a .jpg
plt.close()  # Close the plot

# "/mnt/data/display_output.jpg"  # Return the path to the saved image

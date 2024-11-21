import time
import os

DISPLAY_MEM_START = 0x250004
DISPLAY_MEM_END = 0x269200
DISPLAY_MEM_SIZE = DISPLAY_MEM_END - DISPLAY_MEM_START

def dummy_screen(load_file_path):
    if not os.path.exists(load_file_path):
        print(f"Error: Load file {load_file_path} not found.")
        return
    
    print("\n=== Dummy Screen ===")
    print("Monitoring display memory for updates...")
    
    # Continuously read the display memory region
    prev_display_data = bytearray(DISPLAY_MEM_SIZE)
    while True:
        with open(load_file_path, 'rb') as f:
            # Seek to the start of the display memory
            f.seek(DISPLAY_MEM_START)
            current_display_data = f.read(DISPLAY_MEM_SIZE)
        
        # Compare with the previous display memory content
        if current_display_data != prev_display_data:
            print("\nDisplay Memory Updated:")
            for i in range(0, DISPLAY_MEM_SIZE, 16):  # Print 16 bytes per line
                row = current_display_data[i:i+16]
                if row != prev_display_data[i:i+16]:
                    print(f"{DISPLAY_MEM_START + i:08X}: " + ' '.join(f"{b:02X}" for b in row))
            
            prev_display_data = current_display_data
        
        # Simulate a refresh rate
        time.sleep(0.5)

# Example usage
load_file_path = "asmout.load"  # Replace with the path to your load file
dummy_screen(load_file_path)

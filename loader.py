import os
import sys
import struct
import binascii

class ARMObjectLoader:
    # Memory Address Ranges
    INSTRUCTION_MEM_START = 0x150004
    INSTRUCTION_MEM_END = 0x249996
    KEYBOARD_BUFFER = 0x250000
    DISPLAY_MEM_START = 0x250004
    DISPLAY_MEM_END = 0x269200

    def __init__(self, obj_path):
        """
        Initialize object file loader
        """
        self.obj_path = obj_path
        self.binary_content = None
        self.load_file_content = None
        self.load_file_path = None
    
    def read_object_file(self):
        """
        Read raw object file content
        """
        print(f"Reading object file: {self.obj_path}")
        
        try:
            with open(self.obj_path, 'rb') as obj_file:
                self.binary_content = obj_file.read()
            
            print(f"Object file size: {len(self.binary_content)} bytes")
            return self.binary_content
        except IOError as e:
            print(f"Error reading object file: {e}")
            raise
    
    def generate_load_file(self, output_path=None):
        """
        Generate load file with memory mapping
        """
        # Ensure object file is read
        if self.binary_content is None:
            self.read_object_file()
        
        # Determine output path
        if output_path is None:
            # Generate default output path based on input file
            base_path = os.path.splitext(self.obj_path)[0]
            output_path = f"{base_path}.load"
        
        self.load_file_path = output_path
        
        # Create full memory image
        total_memory_size = 0x269200 + 1
        self.load_file_content = bytearray(b'\x00' * total_memory_size)
        
        # Validate binary size
        max_size = self.INSTRUCTION_MEM_END - self.INSTRUCTION_MEM_START
        if len(self.binary_content) > max_size:
            raise ValueError(f"Binary too large. Max size: {max_size} bytes, Current size: {len(self.binary_content)} bytes")
        
        # Write binary to instruction memory
        start_index = self.INSTRUCTION_MEM_START
        end_index = start_index + len(self.binary_content)
        
        self.load_file_content[start_index:end_index] = self.binary_content
        
        # Write to file
        with open(self.load_file_path, 'wb') as load_file:
            load_file.write(self.load_file_content)
        
        print(f"\nLoad file created: {self.load_file_path}")
        return self.load_file_path
    
    def verify_load_file(self):
        """
        Verify the contents of the load file
        """
        if not self.load_file_path or not os.path.exists(self.load_file_path):
            raise ValueError("Load file not generated or does not exist")
        
        print("\n=== Load File Verification ===")
        
        # Get file size
        file_size = os.path.getsize(self.load_file_path)
        print(f"Load File Path: {self.load_file_path}")
        print(f"Total File Size: {file_size} bytes")
        
        # Read the entire load file
        with open(self.load_file_path, 'rb') as load_file:
            # Verify instruction memory section
            load_file.seek(self.INSTRUCTION_MEM_START)
            instruction_mem = load_file.read(len(self.binary_content))
            
            print("\nInstruction Memory Verification:")
            print("First 32 bytes of Original Binary:")
            original_first_32 = self.binary_content[:32]
            print(' '.join(f'{byte:02X}' for byte in original_first_32))
            
            print("\nFirst 32 bytes in Load File:")
            loaded_first_32 = instruction_mem[:32]
            print(' '.join(f'{byte:02X}' for byte in loaded_first_32))
            
            # Compare contents
            if original_first_32 == loaded_first_32:
                print("\n✅ Instruction Memory VERIFIED")
            else:
                print("\n❌ Instruction Memory MISMATCH")
                
            # Additional verification
            print("\nMemory Section Checks:")
            sections = [
                ("Keyboard Buffer", self.KEYBOARD_BUFFER, 4),
                ("Display Memory", self.DISPLAY_MEM_START, self.DISPLAY_MEM_END - self.DISPLAY_MEM_START)
            ]
            
            for name, start, size in sections:
                load_file.seek(start)
                section_data = load_file.read(size)
                zero_check = all(byte == 0 for byte in section_data)
                
                print(f"{name}: {'Initialized to Zero' if zero_check else 'Contains Non-Zero Data'}")
    
    def export_load_file_for_emulation(self):
        """
        Prepare load file for emulation or further processing
        """
        if not self.load_file_path:
            raise ValueError("Load file not generated")
        
        # Create a JSON or text file with memory layout info
        export_path = f"{self.load_file_path}.json"
        
        memory_layout = {
            "load_file_path": self.load_file_path,
            "memory_regions": {
                "instruction_memory": {
                    "start": self.INSTRUCTION_MEM_START,
                    "end": self.INSTRUCTION_MEM_END,
                    "size": self.INSTRUCTION_MEM_END - self.INSTRUCTION_MEM_START
                },
                "keyboard_buffer": {
                    "start": self.KEYBOARD_BUFFER,
                    "size": 4
                },
                "display_memory": {
                    "start": self.DISPLAY_MEM_START,
                    "end": self.DISPLAY_MEM_END,
                    "size": self.DISPLAY_MEM_END - self.DISPLAY_MEM_START
                }
            },
            "binary_info": {
                "original_file": self.obj_path,
                "binary_size": len(self.binary_content)
            }
        }
        
        import json
        with open(export_path, 'w') as export_file:
            json.dump(memory_layout, export_file, indent=2)
        
        print(f"\nEmulation Export Created: {export_path}")
        return export_path

def main():
    if len(sys.argv) < 2:
        print("Usage: python arm_obj_loader.py <object_file>")
        sys.exit(1)
    
    obj_path = sys.argv[1]
    
    try:
        # Create object file loader
        loader = ARMObjectLoader(obj_path)
        
        # Read object file
        loader.read_object_file()
        
        # Generate load file
        load_file_path = loader.generate_load_file()
        
        # Verify load file contents
        loader.verify_load_file()
        
        # Export for potential emulation
        loader.export_load_file_for_emulation()
    
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()
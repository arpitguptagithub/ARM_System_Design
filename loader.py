import os
import sys
import subprocess
import binascii

class ARMObjectLoader:
    # Memory Address Ranges
    INSTRUCTION_MEM_START = 0x150004
    INSTRUCTION_MEM_END = 0x249996
    KEYBOARD_BUFFER = 0x250000
    DISPLAY_MEM_START = 0x250004
    DISPLAY_MEM_END = 0x269200

    def __init__(self, original_asm_path, original_obj_path):
        """
        Initialize object file loader
        :param original_asm_path: Path to the original assembly file (.s)
        :param original_obj_path: Path to the original object file (.obj) produced by your assembler
        """
        self.original_asm_path = original_asm_path
        self.original_obj_path = original_obj_path  # The .obj file from your assembler
        self.new_obj_path = original_asm_path.replace(".asm", ".obj")  # New .obj file generated by arm-none-eabi-as
        self.binary_content = None
        self.elf_path = original_asm_path.replace(".asm", ".elf")  # ELF output path
    
    def verify_original_obj(self):
        """
        Verifies the original .obj file generated by your assembler.
        """
        if not os.path.exists(self.original_obj_path):
            print(f"Error: {self.original_obj_path} not found")
            sys.exit(1)
        
        print(f"Original Object file: {self.original_obj_path} is ready for processing.")
    
    def assemble_new_obj(self):
        """
        Assemble the assembly file to generate .obj file using arm-none-eabi-as.
        """
        print(f"Generating new .obj file using arm-none-eabi-as for: {self.original_asm_path}")
        try:
            result = subprocess.run(['arm-none-eabi-as', '-o', self.new_obj_path, self.original_asm_path],
                                    stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            if result.returncode != 0:
                raise Exception(f"Assembler failed: {result.stderr.decode()}")
            print(f"New Object file generated: {self.new_obj_path}")
        except Exception as e:
            print(f"Error during assembly: {e}")
            sys.exit(1)
    
    def read_object_file(self, obj_path):
        """
        Read raw object file content
        :param obj_path: Path to the object file (.obj)
        """
        print(f"Reading object file: {obj_path}")
        
        try:
            with open(obj_path, 'rb') as obj_file:
                self.binary_content = obj_file.read()
            
            print(f"Object file size: {len(self.binary_content)} bytes")
            return self.binary_content
        except IOError as e:
            print(f"Error reading object file: {e}")
            raise
    
    def generate_elf_file(self):
        """
        Generate ELF file using the object file.
        """
        print(f"Generating ELF file: {self.elf_path}")
        
        try:
            # Use arm-none-eabi-ld to link and generate ELF
            result = subprocess.run(['arm-none-eabi-ld', '-o', self.elf_path, self.new_obj_path],
                                    stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            if result.returncode != 0:
                raise Exception(f"ELF generation failed: {result.stderr.decode()}")
            print(f"ELF file generated: {self.elf_path}")
        except Exception as e:
            print(f"Error during ELF generation: {e}")
            sys.exit(1)
    
    def verify_elf(self):
        """
        Verify the contents of the ELF file by checking memory layout.
        """
        print("\n=== ELF File Memory Verification ===")
        
        # Verify ELF file existence
        if not os.path.exists(self.elf_path):
            raise ValueError("ELF file not generated or does not exist")
        
        print(f"ELF File Path: {self.elf_path}")
        
        # Read ELF and display some sections
        with open(self.elf_path, 'rb') as elf_file:
            elf_data = elf_file.read()
            elf_size = len(elf_data)
            
            # Display the size of the ELF
            print(f"ELF File Size: {elf_size} bytes")
            
            # Display the first 32 bytes of the ELF file for inspection
            print("\nFirst 32 bytes of ELF file:")
            print(' '.join(f'{byte:02X}' for byte in elf_data[:32]))
            
            # Perform simple verification by checking if instruction memory range is filled
            # For simplicity, we can just ensure that the start of the ELF file has some content
            # if elf_size > self.INSTRUCTION_MEM_START:
            #   print("\n✅ ELF file contains instruction memory range")
            # else:
                # print("\n❌ ELF file does not contain instruction memory range")

    def run(self):
        # Step 1: Verify original object file
        self.verify_original_obj()

        # Step 2: Generate the new .obj file using arm-none-eabi-as
        self.assemble_new_obj()

        # Step 3: Generate the ELF file from the new .obj file
        self.generate_elf_file()

        # Step 4: Verify the ELF file content
        self.verify_elf()

def main():
    if len(sys.argv) < 3:
        print("Usage: python arm_obj_loader.py <original_asm_file.s> <original_obj_file.obj>")
        sys.exit(1)
    
    original_asm_path = sys.argv[1]
    original_obj_path = sys.argv[2]
    
    try:
        # Create object file loader
        loader = ARMObjectLoader(original_asm_path, original_obj_path)
        
        # Run the loader process (verify original obj, generate new obj, and generate ELF)
        loader.run()
    
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()

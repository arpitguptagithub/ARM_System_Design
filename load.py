import struct
import os

class SimpleELFLoader:
    def __init__(self, obj_file_path, elf_file_path):
        self.obj_file_path = obj_file_path
        self.elf_file_path = elf_file_path
        self.sections = []
        self.section_offsets = {}

    def read_object_file(self):
        """
        Read the object file and extract its sections (.text, .data, etc.).
        For simplicity, let's assume the object file consists of raw sections.
        """
        with open(self.obj_file_path, 'rb') as obj_file:
            self.obj_data = obj_file.read()
        
        # Simulating a very simple extraction of sections:
        # Let's assume the .text section starts at byte 0 and .data follows.
        text_section = self.obj_data[0x0:0x1000]  # First 4KB as .text
        data_section = self.obj_data[0x1000:0x2000]  # Next 4KB as .data
        bss_section = b''  # No actual data for .bss (just reserved space)

        # Save sections
        self.sections = [
            { 'name': '.text', 'data': text_section, 'vaddr': 0x10000, 'type': 'PROGBITS' },
            { 'name': '.data', 'data': data_section, 'vaddr': 0x20000, 'type': 'PROGBITS' },
            { 'name': '.bss', 'data': bss_section, 'vaddr': 0x30000, 'type': 'NOBITS' }
        ]

    def create_elf_header(self):
        """
        Create the ELF header for a 32-bit executable.
        """
        # ELF header (52 bytes for 32-bit)
        elf_header = b'\x7F\x45\x4C\x46'  # ELF magic number
        elf_header += b'\x01'  # ELF class: 32-bit
        elf_header += b'\x01'  # Data encoding: little-endian
        elf_header += b'\x01'  # ELF version
        elf_header += b'\x00' * 9  # Padding
        elf_header += struct.pack('<I', 0x10000)  # Entry point (start of .text)
        elf_header += struct.pack('<I', 0x34 + 0x20 * len(self.sections))  # Program header offset
        elf_header += struct.pack('<I', 0x34 + 0x20 * len(self.sections) + 0x28 * len(self.sections))  # Section header offset
        elf_header += struct.pack('<I', 0)  # Flags (set later)
        elf_header += struct.pack('<H', 0x34)  # ELF header size (52 bytes)
        elf_header += struct.pack('<H', 0x20)  # Program header size (32 bytes)
        elf_header += struct.pack('<H', len(self.sections))  # Number of program headers
        elf_header += struct.pack('<H', 0x28)  # Section header size (40 bytes)
        elf_header += struct.pack('<H', len(self.sections))  # Number of section headers
        elf_header += struct.pack('<H', 0)  # Section header string table index (no string table for now)

        return elf_header

    def create_program_header(self, section, offset):
        """
        Create a program header for a section.
        """
        # Program header for loadable segment
        p_type = 1  # PT_LOAD (Loadable segment)
        p_flags = 5  # Execute + Read
        p_offset = offset  # Where the section is in the ELF file
        p_vaddr = section['vaddr']  # Virtual address of section
        p_paddr = section['vaddr']  # Physical address (same for simplicity)
        p_filesz = len(section['data'])  # Size of section in file
        p_memsz = p_filesz if section['type'] == 'PROGBITS' else 0  # Size of section in memory
        p_align = 0x1000  # Alignment

        # Return the program header as a struct (32-bit)
        return struct.pack('<IIIIIIII', p_type, p_flags, p_offset, p_vaddr, p_paddr, p_filesz, p_memsz, p_align)

    def create_section_header(self, section, offset, section_idx):
        """
        Create a section header for a section.
        """
        # Section header for a .text or .data section
        sh_name = section['name'].encode('utf-8') + b'\x00'  # Section name (null-terminated)
        sh_type = 1 if section['type'] == 'PROGBITS' else 8  # SHT_PROGBITS or SHT_NOBITS
        sh_flags = 6 if section['type'] == 'PROGBITS' else 2  # SHF_ALLOC + SHF_EXECINSTR for .text
        sh_addr = section['vaddr']  # Section virtual address
        sh_offset = offset  # Offset in the ELF file
        sh_size = len(section['data'])  # Section size
        sh_link = 0  # No linked section
        sh_info = 0  # No additional information
        sh_addralign = 0x10  # Alignment
        sh_entsize = 0  # Entry size

        # Return the section header as a struct (32-bit)
        return struct.pack('<IIIIIIIIII', len(sh_name) - 1, sh_type, sh_flags, sh_addr, sh_offset, sh_size,
                           sh_link, sh_info, sh_addralign, sh_entsize)

    def write_elf(self):
        """
        Write the ELF file to disk.
        """
        with open(self.elf_file_path, 'wb') as elf_file:
            # Step 1: Write the ELF header
            elf_header = self.create_elf_header()
            elf_file.write(elf_header)

            # Step 2: Write the program headers (we only have one for text+data)
            program_offset = len(elf_header) + 0x20 * len(self.sections)
            for section in self.sections:
                program_header = self.create_program_header(section, program_offset)
                elf_file.write(program_header)

            # Step 3: Write the section headers
            section_offset = program_offset + 0x20 * len(self.sections)
            for i, section in enumerate(self.sections):
                section_header = self.create_section_header(section, section_offset, i)
                elf_file.write(section_header)

            # Step 4: Write section data
            for section in self.sections:
                elf_file.write(section['data'])

    def run(self):
        self.read_object_file()
        self.write_elf()
        print(f"ELF file generated: {self.elf_file_path}")

if __name__ == "__main__":
    obj_file_path = "asmout.obj"  # Example object file path
    elf_file_path = "output.elf"  # Output ELF file path
    loader = SimpleELFLoader(obj_file_path, elf_file_path)
    loader.run()

import re
from collections import defaultdict
from St_Entry import ST_Entry

class Assembler:
    def __init__(self):
        self.opcode = {
            "MOV": 0b00111000,  # 0x38
            "ADD": 0b00000000,  # 0x00
            "ADDS": 0b00000000, # 0x00 with S-bit (sets the condition flags)
            "ADC": 0b00000010,  # 0x02
            "SUB": 0b00000001,  # 0x01
            "SBC": 0b00000110,  # 0x06
            "ORR": 0b00000100,  # 0x04
            "AND": 0b00000000,  # 0x00
            "MVN": 0b00111101,  # 0x3D
            "EOR": 0b00001000,  # 0x08
            "CMP": 0b00001110,  # 0x0E
            "TST": 0b00001101,  # 0x0D
            "LDR": 0b00011000,  # 0x18 (not a data processing operation but a load instruction)
            "STR": 0b00010100,  # 0x14 (not a data processing operation but a store instruction)
            "B":   0b00010111,  # 0x17 (branch instruction)
            "BLT": 0b00001111,  # 0x0F (branch with condition)
            "ADDNE": 0b00000000,  # 0x00 with NE condition
            "ADDEQ": 0b00000000,  # 0x00 with EQ condition
            "STRGT": 0b00010100,  # 0x14 with GT condition (not a data processing operation)
            "ADDGT": 0b00000000,  # 0x00 with GT condition
        }
        self.regcode = {  
            "R0": 0,
            "R1": 1,
            "R2": 2,
            "R3": 3,
            "R4": 4,
            "R5": 5,
            "R6": 6,
            "R7": 7,
            "R8": 8,
            "R9": 9,
            "R10": 10,
            "R11": 11,
            "R12": 12,
            "R13": 13,
            "R14": 14,
            "R15": 15,
        }
        self.shift_codes = {
            "LSL" : 0,
            "LSR" : 1,
            "ASR" : 2, 
            "ROR" : 3
        }
        self.condition_codes = {
        'EQ': '0000',  # Equal
        'NE': '0001',  # Not Equal
        'CS': '0010',  # Carry Set
        'HS': '0010',  # Unsigned Higher or Same
        'CC': '0011',  # Carry Clear
        'LO': '0011',  # Unsigned Lower
        'MI': '0100',  # Minus
        'PL': '0101',  # Plus
        'VS': '0110',  # Overflow Set
        'VC': '0111',  # Overflow Clear
        'HI': '1000',  # Unsigned Higher
        'LS': '1001',  # Unsigned Lower or Same
        'GE': '1010',  # Signed Greater than or Equal
        'LT': '1011',  # Signed Less than
        'GT': '1100',  # Signed Greater than
        'LE': '1101',  # Signed Less than or Equal
        'AL': '1110',  # Always
        'NV': '1111',  # Unpredictable
        '' : '1101'  # if something else is there instead of condition (ADDS)
    }
        self.symbol_table = {}
        self.instructions = []
        self.machine_code = []
        
    def remove_comments_and_spaces(self, instruction):
        """Removes comments and extra spaces from the instruction."""
        # Remove comments after ';'
        instruction = instruction.split(';')[0].strip()
        return instruction

    def tokenize_instruction(self, instruction):
        """Tokenizes instruction and extracts key parts."""
        instruction = self.remove_comments_and_spaces(instruction)

        # Regex to match memory reference with or without immediate values (e.g., [R0] or [R0, #4])
        memory_pattern = r'\[(R\d+)(?:,\s*#?(\d+))?\]'
        tokens = []

        # Split instruction into parts based on commas and spaces, but keep memory references intact
        instruction_parts = re.split(r'\s+|,\s*', instruction)

        # Look for the memory pattern in the instruction
        for part in instruction_parts:
            match = re.match(memory_pattern, part)
            if match:
                tokens.append(match.group(1))  # Register inside []
                if match.group(2):  # Immediate offset, if present
                    tokens.append(f"#{match.group(2)}")
            else:
                tokens.append(part)

        return tokens

    def first_pass(self, source_code):
        lines = source_code.splitlines()
        address = 0

        for line in lines:
            line = line.split(';')[0].strip()  # Remove comments
            if not line:  # Skip empty lines
                continue

            # Handle labels
            label_match = re.match(r'(\w+):\s*(.*)', line)
            if label_match:
                label = label_match.group(1)
                self.symbol_table[label] = ST_Entry(entry_type=0, value=address)
                line = label_match.group(2).strip()  # Continue with the rest of the line

            if line:  # Only count instructions
                self.instructions.append(line)
                address += 4  # Assuming each instruction is 4 bytes
        print(self.symbol_table)
        
    # def tokenize_instruction(self, instruction):
    #     tokens = []
    #     current_token = ''
    #     stack = []

    #     for char in instruction:
    #         if char in '[], ':
    #             if current_token:
    #                 tokens.append(current_token.strip())
    #                 current_token = ''
    #             if char == '[':
    #                 stack.append(len(tokens))
    #                 tokens.append([])
    #             elif char == ']':
    #                 if stack:
    #                     group_start = stack.pop()
    #                     tokens[group_start] = tokens[group_start]
    #                 continue
    #             elif char == ',':
    #                 if current_token:
    #                     tokens.append(current_token.strip())
    #                     current_token = ''
    #                 continue
    #         else:
    #             current_token += char

    #     if current_token:
    #         tokens.append(current_token.strip())

    #     return tokens

    def second_pass(self):
        for instruction in self.instructions:
            print("INST: ", instruction)
            self.machine_code.append(self.encode_instruction(instruction))
    
    def encode_immediate(self, immediate_value):
        # This function encodes immediate values into the ARM format
        if 0 <= immediate_value < 256:
            return f"{immediate_value:08b}"  # 8-bit immediate
        else:
            raise ValueError("Immediate value out of range for this implementation.")
        
    def get_condition(self, instruction_name):
        condition_str = instruction_name[3:].upper()
        print("CONDIT STR ", condition_str)
        if condition_str == "":
            return self.condition_codes["AL"]
        return self.condition_codes[condition_str]
    

    def mov_command(self,instruction_name,  tokens, instruction):
        """
        MOV R0, #20
        Encodes a MOV operation by extracting the destination register and the immediate value.
        """
        rd = self.regcode.get(tokens[0].upper(), None)
        print("RD: ", rd)

        if rd is None:
            raise ValueError("Invalid register")

        # Handle immediate value, expecting it to be in the format #value
        immediate_str = tokens[1].strip('#')
        immediate = int(immediate_str)
        immediate_encoded = self.encode_immediate(immediate_value=immediate)

        # Opcode for MOV
        opcode = self.opcode.get("MOV")

        # Condition and flags
        condition = self.get_condition(instruction_name)
        class_type = '00'   # Data processing
        immediate_flag = '1'  # Immediate flag
        set_flags = '0'     # Not updating flags

        # Final binary instruction
        binary_instruction = (
            f"{condition}"
            f"{class_type}"
            f"{immediate_flag}"
            f"{opcode:08b}"  # Ensure opcode is in 8-bit binary
            f"{set_flags}"
            f"{rd:04b}"      # Ensure rd is in 4-bit binary
            f"0000"          # Unused bits
            f"{immediate_encoded}"  # Immediate value (8-bits)
        )

        print(f"Binary instruction: {binary_instruction}")
        # Check for 32 bits
        if len(binary_instruction) != 32:
            print("LEN: ", len)
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")
        # Convert binary to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex

        return machine_code


    def add_command(self, instruction_name, tokens, instruction, setf = 0):
        """
        ADD R3, R2, R2
        Encodes an ADD operation by extracting the destination register and the two source registers.
        """
        # Get register codes for destination and source registers
        rd = self.regcode.get(tokens[0].upper(), None)  # Destination register
        rn = self.regcode.get(tokens[1].upper(), None)  # First source register
        rm = self.regcode.get(tokens[2].upper(), None)  # Second source register
        is_imm = False
        offset = 0
        
        if None in (rd, rn, rm):
            print("RM IS NONE")
            is_imm = True
            offset = int(tokens[2].split('#')[1]) if '#' in tokens[2] else 0
            
        print(f"TOKENS: {tokens}")
        print(f"RD: {rd}, RN: {rn}, RM: {rm}, offset: {offset}")
        
        # # Validate registers  #NOT REQUIRED HERE
        # if None in (rd, rn, rm):
        #     raise ValueError("Invalid register")

        # Opcode for ADD
        opcode = self.opcode.get("ADD")
        print(f"Opcode for ADD: {opcode}")
        opcode = '0100'
        # Condition and flags
        condition = self.get_condition(instruction_name)
        class_type = '00'   # Data processing
        immediate_flag_extend = '000'  # Not using an immediate value
        if is_imm:
            immediate_flag_extend = '001'
            rm = offset
        set_flags = '0'     # Not updating flags
        if setf:
            set_flags = '1';

        # Final binary instruction
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{immediate_flag_extend}"     # Immediate flag (1 bit)
            f"{opcode}"        # Opcode (6 bits)
            f"{set_flags}"          # Set flags (1 bit)
            f"{rn:04b}"             # First source register (4 bits)
            f"{rd:04b}"             # Destination register (4 bits)
            f"{rm:012b}"            # Second operand (12 bits)
        )

        print(f"Binary instruction: {binary_instruction}")
        # Check for 32 bits
        if len(binary_instruction) != 32:
            print("LEN: ", len)
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")

        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex
        print(f"Machine code: {machine_code}")

        return machine_code


    def adds_command(self,instruction_name,  tokens, instruction):
        """
        ADDS R3, R2, R2
        Encodes an ADDS operation with two registers.
        """
        return self.add_command(tokens, instruction, setf=1)

    
    def adc_command(self, instruction_name, tokens, instruction):
        """
        ADC R3, R2, R2
        Encodes an ADC operation by extracting the destination register and the two source registers.
        """
        # Get register codes for destination and source registers
        rd = self.regcode.get(tokens[0].upper(), None)  # Destination register
        rn = self.regcode.get(tokens[1].upper(), None)  # First source register
        rm = self.regcode.get(tokens[2].upper(), None)  # Second source register

        print(f"TOKENS: {tokens}")
        print(f"RD: {rd}, RN: {rn}, RM: {rm}")

        # Validate registers
        if None in (rd, rn, rm):
            raise ValueError("Invalid register")

        # Opcode for ADC
        opcode = self.opcode.get("ADC")
        print(f"Opcode for ADC: {opcode}")

        # Condition and flags
        condition = self.get_condition(instruction_name)
        immediate_flag = '0'     # Not using an immediate value
        set_flags = '0'          # Not updating flags
        class_type = '00'        # Data processing

        # Final binary instruction
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{immediate_flag}"     # Immediate flag (1 bit)
            f"{opcode:04b}"        # Opcode (6 bits)
            f"{set_flags}"          # Set flags (1 bit)
            f"{rn:04b}"             # First source register (4 bits)
            f"{rd:04b}"             # Destination register (4 bits)
            f"{rm:012b}"            # Second operand (12 bits) - need to ensure it's correctly formatted
        )

        # Check the length of the final binary instruction
        if len(binary_instruction) != 32:
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")

        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex

        return machine_code

    def sub_command(self, instruction_name, tokens, instruction):
        """
        Converts SUB R5, R4, R4, LSL #2 to binary.
        """
        # Get register codes for destination and source registers
        rd = self.regcode.get(tokens[0].upper(), None)  # Destination register (R5)
        rn = self.regcode.get(tokens[1].upper(), None)  # First source register (R4)
        rm = self.regcode.get(tokens[2].upper(), None)  # Second source register (R4)

        print(f"TOKENS: {tokens}")
        
        # Validate registers
        if None in (rd, rn, rm):
            raise ValueError("Invalid register")

        shift_type_str = tokens[3].upper() 
        shift_amount_str = tokens[4].strip('#')  
        shift_amount = int(shift_amount_str)  

        shift_type = self.shift_codes.get(shift_type_str)
        if shift_type is None:
            raise ValueError(f"Invalid shift type: {shift_type_str}")

        print(f"RD: {rd}, RN: {rn}, RM: {rm}, Shift Type: {shift_type}, Shift Amount: {shift_amount}")

        # Opcode for SUB
        opcode = self.opcode.get("SUB")
        print(f"Opcode for SUB: {opcode}")

        # Condition and flags
        condition = self.get_condition(instruction_name)
        immediate_flag = '0'  # Not using an immediate value
        class_type = '00'   # Data processing
        set_flags = '0'     # Not updating flags

        # Shift amount (6 bits) and encode as binary
        shift_amount_binary = f"{shift_amount:06b}"  # 6 bits for shift amount

        # Final binary instruction
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{immediate_flag}"     # Immediate flag (1 bit)
            f"{opcode:04b}"        # Opcode (4 bits, modify as per your opcode bit length)
            f"{set_flags}"          # Set flags (1 bit)
            f"{rn:04b}"             # First source register (4 bits)
            f"{rd:04b}"             # Destination register (4 bits)
            f"{rm:04b}"             # Second source register (4 bits)
            f"{shift_type}"         # Shift type (2 bits)
            f"{shift_amount_binary}" # Shift amount (6 bits)
        )

        print(f"Binary instruction: {binary_instruction}")
        
        # Check for 32 bits
        if len(binary_instruction) != 32:
            print("LEN: ", len)
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")

        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex

        return machine_code

    def sbc_command(self, instruction_name, tokens, instruction):
        """
        Converts SUB R5, R4, R4, LSL #2 to binary.
        """
        # Get register codes for destination and source registers
        rd = self.regcode.get(tokens[0].upper(), None)  # Destination register (R5)
        rn = self.regcode.get(tokens[1].upper(), None)  # First source register (R4)
        rm = self.regcode.get(tokens[2].upper(), None)  # Second source register (R4)

        print(f"TOKENS: {tokens}")
        
        # Validate registers
        if None in (rd, rn, rm):
            raise ValueError("Invalid register")

        shift_type_str = tokens[3].upper() 
        shift_amount_str = tokens[4].strip('#')  
        shift_amount = int(shift_amount_str)  

        shift_type = self.shift_codes.get(shift_type_str)
        if shift_type is None:
            raise ValueError(f"Invalid shift type: {shift_type_str}")

        print(f"RD: {rd}, RN: {rn}, RM: {rm}, Shift Type: {shift_type}, Shift Amount: {shift_amount}")

        # Opcode for SUB
        opcode = self.opcode.get("SBC")
        print(f"Opcode for SUB: {opcode}")

        # Condition and flags
        condition = self.get_condition(instruction_name)
        immediate_flag = '0'  # Not using an immediate value
        class_type = '00'   # Data processing
        set_flags = '0'     # Not updating flags

        # Shift amount (6 bits) and encode as binary
        shift_amount_binary = f"{shift_amount:06b}"  # 6 bits for shift amount

        # Final binary instruction
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{immediate_flag}"     # Immediate flag (1 bit)
            f"{opcode:04b}"        # Opcode (4 bits, modify as per your opcode bit length)
            f"{set_flags}"          # Set flags (1 bit)
            f"{rn:04b}"             # First source register (4 bits)
            f"{rd:04b}"             # Destination register (4 bits)
            f"{rm:04b}"             # Second source register (4 bits)
            f"{shift_type}"         # Shift type (2 bits)
            f"{shift_amount_binary}" # Shift amount (6 bits)
        )
        print(f"Binary instruction: {binary_instruction}")
        
        # Check for 32 bits
        if len(binary_instruction) != 32:
            print("LEN: ", len)
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")


        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex

        return machine_code
    
    def orr_command(self, instruction_name, tokens, instruction):
        """
        Converts ORR R7, R5, R2, ASR #2 to binary.
        """
        rd = self.regcode.get(tokens[0].upper(), None)  # Destination register (R5)
        rn = self.regcode.get(tokens[1].upper(), None)  # First source register (R4)
        rm = self.regcode.get(tokens[2].upper(), None)  # Second source register (R4)

        print(f"TOKENS: {tokens}")
        
        # Validate registers
        if None in (rd, rn, rm):
            raise ValueError("Invalid register")

        shift_type_str = tokens[3].upper() 
        shift_amount_str = tokens[4].strip('#')  
        shift_amount = int(shift_amount_str)  

        shift_type = self.shift_codes.get(shift_type_str)
        if shift_type is None:
            raise ValueError(f"Invalid shift type: {shift_type_str}")

        print(f"RD: {rd}, RN: {rn}, RM: {rm}, Shift Type: {shift_type}, Shift Amount: {shift_amount}")

        # Opcode for SUB
        opcode = self.opcode.get("ORR")
        print(f"Opcode for SUB: {opcode}")

        # Condition and flags
        condition = self.get_condition(instruction_name)
        immediate_flag = '0'  # Not using an immediate value
        class_type = '00'   # Data processing
        set_flags = '0'     # Not updating flags

        # Shift amount (6 bits) and encode as binary
        shift_amount_binary = f"{shift_amount:06b}"  # 6 bits for shift amount
        
        opcode_and_before = "011100"
        # Final binary instruction  
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{immediate_flag}"     # Immediate flag (1 bit)
            f"{opcode_and_before}"        # Opcode (4 bits)
            f"{set_flags}"          # Set flags (1 bit)
            f"{rn:04b}"             # First source register (4 bits)
            f"{rd:04b}"             # Destination register (4 bits)
            f"{rm:04b}"             # Second source register (4 bits)
            f"{shift_type:02b}"     # Shift type (2 bits) - convert to binary string
            f"{shift_amount_binary}" # Shift amount (6 bits)
        )
        # Check for 32 bits
        if len(binary_instruction) != 32:
            print("LEN ", len(binary_instruction))
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")

        print(f"Binary instruction: {binary_instruction}")

        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex

        return machine_code
    
    def and_command(self, instruction_name, tokens, instructions):
        """
        Converts AND R8, R7, R3 to binary.
        """
        # Get register codes for destination and source registers
        rd = self.regcode.get(tokens[0].upper(), None)  # Destination register
        rn = self.regcode.get(tokens[1].upper(), None)  # First source register
        rm = self.regcode.get(tokens[2].upper(), None)  # Second source register

        print(f"TOKENS: {tokens}")
        print(f"RD: {rd}, RN: {rn}, RM: {rm}")

        # Validate registers
        if None in (rd, rn, rm):
            raise ValueError("Invalid register")

        # Opcode for ADC
        opcode = self.opcode.get("AND")
        print(f"Opcode for ADC: {opcode}")

        # Condition and flags
        condition = self.get_condition(instruction_name)
        immediate_flag = 0     # Not using an immediate value
        set_flags = '0'          # Not updating flags
        class_type = '00'        # Data processing

        # Final binary instruction
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{immediate_flag:03b}"     # Immediate flag (1 bit)
            f"{opcode:04b}"        # Opcode (6 bits)
            f"{set_flags}"          # Set flags (1 bit)
            f"{rn:04b}"             # First source register (4 bits)
            f"{rd:04b}"             # Destination register (4 bits)
            f"{rm:012b}"            # Second operand (12 bits) - need to ensure it's correctly formatted
        )

        # Check the length of the final binary instruction
        if len(binary_instruction) != 32:
            print("LEN ", len(binary_instruction))
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")

        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex

        return machine_code
    
    def mvn_command(self, instruction_name, tokens, instructions):
        """
        Converts MVN R9, R6 to binary.
        """
        # Get register codes for destination and source registers
        rd = self.regcode.get(tokens[0].upper(), None)  # Destination register
        rn = 0
        rm = self.regcode.get(tokens[1].upper(), None)  # Second source register

        print(f"TOKENS: {tokens}")
        print(f"RD: {rd}, RN: {rn}, RM: {rm}")

        # Validate registers
        if None in (rd, rn, rm):
            raise ValueError("Invalid register")

        # Opcode for ADC
        opcode = self.opcode.get("MVN")
        print(f"Opcode for ADC: {opcode}")
        opcode = "1111"
        # Condition and flags
        condition = self.get_condition(instruction_name)
        immediate_flag = 0     # Not using an immediate value
        set_flags = '0'          # Not updating flags
        class_type = '00'        # Data processing

        # Final binary instruction
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{immediate_flag:03b}"     # Immediate flag (1 bit)
            f"{opcode}"        # Opcode (6 bits)  #opcode givin in arm website as 1111
            f"{set_flags}"          # Set flags (1 bit)
            f"{rn:04b}"             # First source register (4 bits)
            f"{rd:04b}"             # Destination register (4 bits)
            f"{rm:012b}"            # Second operand (12 bits) - need to ensure it's correctly formatted
        )
        # barray = [
        #     f"{condition}"     ,     # Condition (4 bits)
        #     f"{immediate_flag:03b}" ,    # Immediate flag (1 bit)
        #     f"{opcode:04b}"     ,   # Opcode (6 bits)
        #     f"{set_flags}"    ,      # Set flags (1 bit)
        #     f"{rn:04b}"      ,       # First source register (4 bits)
        #     f"{rd:04b}"      ,       # Destination register (4 bits)
        #     f"{rm:012b}"     ,       # Second operand (12 bits) - need to ensure it's correctly formatted
        
        # ]
        # print("BARRY: ")
        # for x in barray:
        #     print(x + " ,")
        # Check the length of the final binary instruction
        if len(binary_instruction) != 32:
            print("LEN ", len(binary_instruction))
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")

        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex

        return machine_code

    def eor_command(self, instruction_name, tokens, instructions):
        """
        Converts EOR R10, R4, R5 to binary.
        """
        rd = self.regcode.get(tokens[0].upper(), None)  # Destination register
        rn = self.regcode.get(tokens[1].upper(), None)  # First source register
        rm = self.regcode.get(tokens[2].upper(), None)  # Second source register

        print(f"TOKENS: {tokens}")
        print(f"RD: {rd}, RN: {rn}, RM: {rm}")

        # Validate registers
        if None in (rd, rn, rm):
            raise ValueError("Invalid register")

        # Opcode for ADC
        opcode = self.opcode.get("MVN")
        print(f"Opcode for ADC: {opcode}")
        opcode = "0001" #GOT OPCODE FROM ARM WEBSITE
        # Condition and flags
        condition = self.get_condition(instruction_name)
        immediate_flag = 0     # Not using an immediate value
        set_flags = '0'          # Not updating flags
        class_type = '00'        # Data processing

        # Final binary instruction
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{immediate_flag:03b}"     # Immediate flag (1 bit)
            f"{opcode}"        # Opcode (6 bits)  #opcode givin in arm website as 1111
            f"{set_flags}"          # Set flags (1 bit)
            f"{rn:04b}"             # First source register (4 bits)
            f"{rd:04b}"             # Destination register (4 bits)
            f"{rm:012b}"            # Second operand (12 bits) - need to ensure it's correctly formatted
        )
    
        if len(binary_instruction) != 32:
            print("LEN ", len(binary_instruction))
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")

        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex

        return machine_code
    
    def cmp_command(self, instruction_name, tokens, instructions):
        """
        Converts CMP R8, R6 to binary.
        """
        rd = 0
        rn = self.regcode.get(tokens[0].upper(), None)  # First register (R8)
        rm = self.regcode.get(tokens[1].upper(), None)  # Second register (R6)
        
        print(f"TOKENS: {tokens}")
        print(f"RD: {rd}, RN: {rn}, RM: {rm}")
        
        # Validate registers
        if None in (rn, rm):
            raise ValueError("Invalid register")

        # Opcode for CMP
        opcode = '1010'  # CMP opcode in 4 bits

        # Condition and flags
        condition = self.get_condition(instruction_name)
        immediate_flag = 0  # Using registers (1 bit)
        set_flags = '1'  # CMP sets flags

        # Final binary instruction
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{immediate_flag:03b}"     # Immediate flag (1 bit)
            f"{opcode}"             # Opcode (4 bits)
            f"{set_flags}"          # Set flags (1 bit)
            f"{rn:04b}"             # First register (4 bits)
            f"{rd:04b}"               # Rd is not used (4 bits)
            f"{rm:012b}"             # Second register (4 bits)
        )

        # Check for 32 bits
        if len(binary_instruction) != 32:
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")
        print("BIN ", binary_instruction)
        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex

        return machine_code
    
    def tst_command(self, instruction_name, tokens, instruction):
        """
        Converts TST R9, R8 to binary.
        """
        rd = 0
        rn = self.regcode.get(tokens[0].upper(), None)  # First source register (Rn)
        rm = self.regcode.get(tokens[1].upper(), None)  # Second source register (Rm)
        print(f"TOKENS: {tokens}")
        print(f"RD: {rd}, RN: {rn}, RM: {rm}")

        # Validate registers
        if None in (rn, rm):
            raise ValueError("Invalid register")

        # Opcode for TST
        opcode = '1000'  # TST opcode in 4 bits

        # Condition and flags
        condition = self.get_condition(instruction_name)
        immediate_flag = 0  # Using registers (1 bit)
        set_flags = '1'      # Not updating flags (not used in TST)

        # Final binary instruction
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{immediate_flag:03b}"     # Immediate flag (1 bit)
            f"{opcode}"             # Opcode (4 bits)
            f"{set_flags}"          # Set flags (1 bit)
            f"{rn:04b}"             # First register (4 bits)
            f"{rd:04b}"               # Rd is not used (4 bits)
            f"{rm:012b}"             # Second register (4 bits)
        )

        # Check for 32 bits
        if len(binary_instruction) != 32:
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")

        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex

        return machine_code
    
    def str_command(self, instruction_name, tokens, instruction):
        """
        Converts STR R1, [R0], #0 to binary.
        """
        rt = self.regcode.get(tokens[0].upper(), None)  # Register to store (Rt)
        rn = self.regcode.get(tokens[1].upper().split(',')[0], None)  # Base register (Rn)
        offset = int(tokens[1].split('#')[1]) if '#' in tokens[1] else 0  # Immediate offset

        print(f"TOKENS: {tokens}")
        print(f"RT: {rt}, RN: {rn}, OFFSET: {offset}")

        # Validate registers
        if None in (rt, rn):
            raise ValueError("Invalid register")

        # Encoding values
        condition = self.get_condition(instruction_name)
        immediate_flag_extended = '010'  # Using immediate (1 bit)
        P = '0'  # Post-indexed addressing (0)
        U = '1'  # Offset is added (1)
        W = '0'  # No writeback (0)
        set_flags = '0' 
        
        # Immediate value must be in the range of 12 bits
        imm12 = f"{offset:012b}"  # Convert offset to 12 bits

        # Final binary instruction
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{immediate_flag_extended}"     # Immediate flag (1 bit)
            f"{P}{U}0{W}"           # P, U, 0, W (4 bits)
            f"{set_flags}"          # Set flags (1 bit)
            f"{rn:04b}"             # Base register (Rn) (4 bits)
            f"{rt:04b}"             # Register to store (Rt) (4 bits)
            f"{imm12}"              # Immediate value (12 bits)
        )

        # Check for 32 bits
        if len(binary_instruction) != 32:
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")

        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex

        return machine_code

    
    def ldr_command(self, instruction_name, tokens, instruction):
        """
        Converts LDR R11, [R0], #0 to binary.
        """
        rt = self.regcode.get(tokens[0].upper(), None)  # Register to load (Rt)
        rn = self.regcode.get(tokens[1].upper().split(',')[0], None)  # Base register (Rn)
        offset = int(tokens[1].split('#')[1]) if '#' in tokens[1] else 0  # Immediate offset

        print(f"TOKENS: {tokens}")
        print(f"RT: {rt}, RN: {rn}, OFFSET: {offset}")

        # Validate registers
        if None in (rt, rn):
            raise ValueError("Invalid register")

        # Encoding values
        condition = self.get_condition(instruction_name)
        immediate_flag_extended = '010'  # Using immediate (1 bit)
        P = '0'  # Post-indexed addressing (0)
        U = '1'  # Offset is added (1)
        W = '0'  # No writeback (0)

        # Immediate value must be in the range of 12 bits
        imm12 = f"{offset:012b}"  # Convert offset to 12 bits

        set_flags = '1'
        
        # Final binary instruction
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{immediate_flag_extended}"     # Immediate flag (1 bit)
            f"{P}{U}0{W}"           # P, U, 0, W (4 bits)
            f"{set_flags}"  
            f"{rn:04b}"             # Base register (Rn) (4 bits)
            f"{rt:04b}"             # Register to load (Rt) (4 bits)
            f"{imm12}"              # Immediate value (12 bits)
        )

        # Check for 32 bits
        if len(binary_instruction) != 32:
            print("LEN: ", len)
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")

        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex

        return machine_code
    
    def blt_command(self, instruction_name, tokens):
        """
        Encodes the BLT (Branch if Less Than) instruction with an immediate offset ["BLT", "#-9"]
        """
        # Condition for BLT
        condition = '1010'  # Condition code for BLT (less than)
        opcode = '1110'     # Opcode for branch with link (BL)
        
        # Parse the immediate value from the token
        immediate_offset = int(tokens[1].replace('#', ''))
        print("IMM OFFSET ", immediate_offset)
        # Calculate the immediate value for the offset
        immediate_value = immediate_offset // 4  # Immediate value in words

        # Convert the immediate value to a 24-bit two's complement binary representation
        if immediate_value < 0:
            immediate_value = (1 << 24) + immediate_value  # Convert to unsigned

        # Format the immediate value as a 24-bit binary string
        immediate_binary = f"{immediate_value:024b}"

        # Construct the final binary instruction
        binary_instruction = (
            f"{condition}"   # Condition (4 bits)
            f"00"            # Unused bits (2 bits)
            f"{opcode}"      # Opcode (4 bits)
            f"1"             # Link bit (1 bit)
            f"{immediate_binary}"  # Immediate value (24 bits)
        )

        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex

        return machine_code


    # You can replicate similar functions for other instructions like SUB, SBC, ORR, etc.

    def encode_instruction(self, instruction):
        tokens = self.tokenize_instruction(instruction)
        print("TOKENS: ", tokens)
        instruction_name = tokens[0].upper()

        if instruction_name == "MOV":
            return self.mov_command(instruction_name, tokens[1:], instruction)
        elif "ADD" in instruction_name:
            return self.add_command(instruction_name, tokens[1:], instruction)
        elif instruction_name == "ADDS":
            return self.adds_command(instruction_name, tokens[1:], instruction)
        elif instruction_name == "LDR":
            return self.ldr_command(instruction_name, tokens[1:], instruction)
        elif instruction_name == "ADC":
            return self.adc_command(instruction_name, tokens[1:], instruction)
        elif instruction_name == "SUB":
            return self.sub_command(instruction_name, tokens[1:], instruction)
        elif instruction_name == "SBC":
            return self.sbc_command(instruction_name, tokens[1:], instruction)
        elif instruction_name == "ORR":
            return self.orr_command(instruction_name, tokens[1:], instruction)
        elif instruction_name == "AND":
            return self.and_command(instruction_name, tokens[1:], instruction)
        elif instruction_name == "MVN":
            return self.mvn_command(instruction_name, tokens[1:], instruction)
        elif instruction_name == "EOR":
            return self.eor_command(instruction_name, tokens[1:], instruction)
        elif instruction_name == "CMP":
            return self.cmp_command(instruction_name, tokens[1:], instruction)
        elif instruction_name == "TST":
            return self.tst_command(instruction_name, tokens[1:], instruction)
        elif instruction_name == "STR":
            return self.str_command(instruction_name, tokens[1:], instruction)
        elif instruction_name == "LDR":
            return self.ldr_command(instruction_name, tokens[1:], instruction)
        else:
            raise ValueError(f"Unknown instruction: {instruction}")

    def assemble(self, source_code):
        self.first_pass(source_code)
        self.second_pass()
        return self.machine_code


# Example usage
if __name__ == "__main__":
    source_code = """
    start:
    ADDNE   R1, R1, R1
    """
    
    assembler = Assembler()
    machine_code = assembler.assemble(source_code)
    print(f"Machine code: {machine_code}")
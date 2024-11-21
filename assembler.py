import re
from collections import defaultdict
from St_Entry import ST_Entry

class Assembler:
    def __init__(self):
        self.opcode = {
            "MOV": "1101", 
            "ORR": "1100", 
            "ADD" : "0100",
            "ADC" : "0101",
            "SUB" : "0010", 
            "SBC" : "0110",
            "MVN" : "1111",
            "EOR" : "0001",
            "CMP" : "1010",
            "TST" : "1000",
            "AND" : "0000",
            "STR" : "0100",
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
            "PC" : 15,
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
        '' : '1110'  # if something else is there instead of condition (ADDS)
    }
        self.symbol_table = {}
        self.instructions = []
        self.machine_code = []
        self.current_address = 0
        
    def remove_comments_and_spaces(self, instruction):
        """Removes comments and extra spaces from the instruction."""
        # Remove comments after ';'
        instruction = instruction.split(';')[0].strip()
        return instruction

    import re

    def tokenize_instruction(self, instruction):
        """Tokenizes instruction and extracts key parts."""
        instruction = self.remove_comments_and_spaces(instruction)

        # Regex to match memory reference with or without immediate values
        memory_pattern = r'\[(R\d+)(?:,\s*#?(\d+))?\]'
        
        tokens = []

        # Split instruction into parts based on commas and spaces but keep memory references intact
        instruction_parts = re.split(r',\s*|\s+', instruction)

        for part in instruction_parts:
            # Check for memory pattern matches
            match = re.match(memory_pattern, part.strip())
            if match:
                tokens.append(match.group(1))  # Register inside []
                if match.group(2):  # Immediate offset, if present
                    tokens.append(f"#{match.group(2)}")
            else:
                # If part has brackets but wasn't matched, check if it can be split
                if '[' in part and ']' in part:
                    inner_match = re.match(r'\[(R\d+)\]', part)
                    if inner_match:
                        tokens.append(inner_match.group(1))
                        # Check for immediate value
                        immediate_match = re.search(r',\s*#?(\d+)', part)
                        if immediate_match:
                            tokens.append(f"#{immediate_match.group(1)}")
                else:
                    part = part.strip()  # Clean any whitespace
                    if part:  # Ensure we don't append empty tokens
                        tokens.append(part)

        return tokens
    
    def is_label(self, label):
        print("check label:", label)
        if not label:
            return False
       
        # Check if the first character is a letter
        if not label[0].isalpha():
            print("c1 ")
            return False
        
        # Check if all characters are uppercase letters, digits, or underscores
        for char in label[1:]:
            if not (char.isalpha() or char.isdigit() or char == '_'):
                print("c2 ", char)
                return False
        
        return True

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
                label = label.strip()
                if not self.is_label(label):
                    raise ValueError(f"Invalid label: {label}")
                
                #as of now only storing labels, can extend to other sections by changing the entry_type
                self.symbol_table[label] = ST_Entry(entry_type=0, value=address)
                line = label_match.group(2).strip()  # Continue with the rest of the line

            if line:  # Only count instructions
                self.instructions.append(line)
                if not ".global" in line:
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
        self.current_address = 0
        for instruction in self.instructions:
            print("INST: ", instruction)
            # self.encode_instruction(instruction)
            self.machine_code.append(self.encode_instruction(instruction))
            self.current_address += 4
        print("SYMBOL TABLE \n", self.symbol_table)
    
    def encode_immediate(self, immediate_value):
        # The immediate value needs to fit within the last 12 bits of the 32-bit instruction
        if 0 <= immediate_value < (1 << 32):  # 0 to 4095 (12 bits)
            return f"{immediate_value:012b}"  # Return as 12-bit binary
        else:
            raise ValueError("Immediate value out of range for this implementation.")
        
    def get_condition(self, instruction_name):
        condition_str = instruction_name[3:].upper()
        print("CONDIT STR ", condition_str)
        
        if condition_str == "":
            return self.condition_codes["AL"]
        if condition_str[0] == 'S':
            condition_str = condition_str[1:]
        try:
            return self.condition_codes[condition_str]
        except KeyError:
            return "1110"  # Default to "1101" in case of an error
    
    def get_set_flag(self, instruction_name):
        instruction_name = instruction_name[3:].upper()
        if instruction_name == "":
            return '0'
        if instruction_name[0] == 'S':
            return '1'
        
    def get_imm(self, immediate_str):
        if immediate_str.startswith("0x"):
            immediate = int(immediate_str, 16)
        else:
            immediate = int(immediate_str)
        return immediate
    
    def mov_command(self,instruction_name,  tokens, instruction):
        """
        MOV R0, #20
        Encodes a MOV operation by extracting the destination register and the immediate value.
        
        """
        print("TOKENS: ", tokens)
        rd = self.regcode.get(tokens[0].upper(), None)
        rm = None
        print("RD: ", rd)

        if rd is None:
            raise ValueError("Invalid register")
        
        if re.match(r'R\d+', tokens[1].upper()):
            rm = self.regcode.get(tokens[1].upper(), None)
        else:
            # Handle immediate value, expecting it to be in the format #value
            immediate_str = tokens[1].strip('#')
            immediate = self.get_imm(immediate_str)
            immediate_encoded = self.encode_immediate(immediate_value=immediate)

        # Opcode for MOV
        opcode = self.opcode.get("MOV")
        print("OPCODE ", opcode)
        # Condition and flags
        condition = self.get_condition(instruction_name)
        class_type = '00'   # Data processing
        immediate_flag = '0'  # Immediate flag
        if rm is None:
            immediate_flag = '1'
        set_flags = self.get_set_flag(instruction_name)     # Not updating flags

        # Final binary instruction
        binary_instruction = ()
        if rm is None:
            binary_instruction = (
                f"{condition}"
                f"{class_type}"
                f"{immediate_flag}"
                f"{opcode}"  # Ensure opcode is in 8-bit binary
                f"{set_flags}"
                f"0000"          # Unused bits
                f"{rd:04b}" 
                f"{immediate_encoded}"  # Immediate value (8-bits)
            )
        else:
            binary_instruction = (
                f"{condition}"
                f"{class_type}"
                f"{immediate_flag}"
                f"{opcode}"  # Ensure opcode is in 8-bit binary
                f"{set_flags}"
                f"0000"
                f"{rd:04b}"      # Ensure rd is in 4-bit binary
                f"00000000"
                f"{rm:04b}"      # Ensure rm is in 4-bit binary
            )
        print(f"Binary instruction: {binary_instruction}")
        # Check for 32 bits
        if len(binary_instruction) != 32:
            print("LEN: ", len(binary_instruction))
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
            offset = self.get_imm(tokens[2].split('#')[1]) if '#' in tokens[2] else 0
            print("OFFSET ADD ", offset)
            
        print(f"TOKENS: {tokens}")
        print(f"RD: {rd}, RN: {rn}, RM: {rm}, offset: {offset}")
        
        # # Validate registers  #NOT REQUIRED HERE
        # if None in (rd, rn, rm):
        #     raise ValueError("Invalid register")

        # Opcode for ADD
        opcode = self.opcode.get("ADD")
        print(f"Opcode for ADD: {opcode}")
        # Condition and flags
        condition = self.get_condition(instruction_name)
        class_type = '00'   # Data processing
        immediate_flag_extend = '000'  # Not using an immediate value
        if is_imm:
            immediate_flag_extend = '001'
            rm = offset
        set_flags = self.get_set_flag(instruction_name)   
        print("S: ", set_flags)
        # Final binary instruction
        if is_imm:
            binary_instruction = (
                f"{condition}"          # Condition (4 bits)
                f"{immediate_flag_extend}"     # Immediate flag (1 bit)
                f"{opcode}"        # Opcode (6 bits)
                f"{set_flags}"          # Set flags (1 bit)
                f"{rn:04b}"             # First source register (4 bits)
                f"{rd:04b}"             # Destination register (4 bits)
                f"{rm:012b}"            # Second operand (12 bits)
            )
        else:
            binary_instruction = (
                f"{condition}"          # Condition (4 bits)
                f"{immediate_flag_extend}"     # Immediate flag (1 bit)
                f"{opcode}"        # Opcode (6 bits)
                f"{set_flags}"          # Set flags (1 bit)
                f"{rn:04b}"             # First source register (4 bits)
                f"{rd:04b}"             # Destination register (4 bits)
                f"00000000"
                f"{rm:04b}"            # Second operand (12 bits)
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

    
    def adc_command(self, instruction_name, tokens, instruction, setf = 0):
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
        set_flags = self.get_set_flag(instruction_name)   
        class_type = '00'  
        ['E3A00014', 'E0823002', 'D0923002', 'E1E09006', 'E024A005', 'E0A04000']
        # Final binary instruction
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{class_type}"
            f"{immediate_flag}"     # Immediate flag (1 bit)
            f"{opcode}"        # Opcode (6 bits)
            f"{set_flags}"          # Set flags (1 bit)
            f"{rn:04b}"             # First source register (4 bits)
            f"{rd:04b}"             # Destination register (4 bits)
            f"{rm:012b}"            # Second operand (12 bits) - need to ensure it's correctly formatted
        )
        print(f"Binary instruction: {binary_instruction}")
        # Check the length of the final binary instruction
        if len(binary_instruction) != 32:
            print("LEN ", len(binary_instruction))
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")

        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex

        return machine_code
    
    
    def sub_command(self, instruction_name, tokens, instruction):
        # Get register codes for destination and source registers
        rd = self.regcode.get(tokens[0].upper(), None)  # Destination register
        rn = self.regcode.get(tokens[1].upper(), None)  # First source register
        rm = self.regcode.get(tokens[2].upper(), None)  # Second source register
        is_imm = False
        offset = 0
        
        if None in (rd, rn, rm):
            print("RM IS NONE")
            is_imm = True
            offset = self.get_imm(tokens[2].split('#')[1]) if '#' in tokens[2] else 0
            print("OFFSET SUB ", offset)
            
        print(f"TOKENS: {tokens}")
        print(f"RD: {rd}, RN: {rn}, RM: {rm}, offset: {offset}")
        
        # # Validate registers  #NOT REQUIRED HERE
        # if None in (rd, rn, rm):
        #     raise ValueError("Invalid register")

        # Opcode for ADD
        opcode = self.opcode.get("SUB")
        print(f"Opcode for SUB: {opcode}")
        # Condition and flags
        condition = self.get_condition(instruction_name)
        class_type = '00'   # Data processing
        immediate_flag_extend = '000'  # Not using an immediate value
        if is_imm:
            immediate_flag_extend = '001'
            rm = offset
        set_flags = self.get_set_flag(instruction_name)   
        print("S: ", set_flags)
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

    # def sub_command(self, instruction_name, tokens, instruction):
    #     """
    #     Converts SUB R5, R4, R4, LSL #2 to binary.
    #     how to make this work for SUB R7, R7, #4??
    #     """
    #     # Get register codes for destination and source registers
    #     rd = self.regcode.get(tokens[0].upper(), None)  # Destination register (R5)
    #     rn = self.regcode.get(tokens[1].upper(), None)  # First source register (R4)
    #     rm = self.regcode.get(tokens[2].upper(), None)  # Second source register (R4)

    #     print(f"TOKENS: {tokens}")
        
    #     # Validate registers
    #     if None in (rd, rn, rm):
    #         raise ValueError("Invalid register")

    #     shift_type_str = tokens[3].upper() 
    #     shift_amount_str = tokens[4].strip('#')  
    #     shift_amount = self.get_imm(shift_amount_str)  
    #     print("SHIFT AMT ", shift_amount)
    #     shift_type = self.shift_codes.get(shift_type_str)
    #     if shift_type is None:
    #         raise ValueError(f"Invalid shift type: {shift_type_str}")

    #     print(f"RD: {rd}, RN: {rn}, RM: {rm}, Shift Type: {shift_type}, Shift Amount: {shift_amount}")

    #     # Opcode for SUB
    #     opcode = self.opcode.get("SUB")
    #     print(f"Opcode for SUB: {opcode}")

    #     # Condition and flags
    #     condition = self.get_condition(instruction_name)
    #     immediate_flag = '0'  # Not using an immediate value
    #     class_type = '00'   # Data processing
    #     set_flags = self.get_set_flag(instruction_name)   

    #     # Shift amount (6 bits) and encode as binary
    #     shift_amount_binary = f"{shift_amount:05b}"  # 6 bits for shift amount
    #     print("SABIN ", shift_amount_binary)
    #     # Final binary instruction
    #     print("SHFT TYPE ", shift_type)
    #     binary_instruction = (
    #         f"{condition}"          # Condition (4 bits)
    #         f"{class_type}"
    #         f"{immediate_flag}"     # Immediate flag (1 bit)
    #         f"{opcode}"        # Opcode (4 bits, modify as per your opcode bit length)
    #         f"{set_flags}"          # Set flags (1 bit)
    #         f"{rn:04b}"             # First source register (4 bits)
    #         f"{rd:04b}"             # Destination register (4 bits)
    #         f"{shift_amount_binary}" # Shift amount (6 bits)
    #         f"{shift_type:02b}"         # Shift type (2 bits)
    #         f"0"
    #         f"{rm:04b}"             # Second source register (4 bits)
    #     )

    #     print(f"Binary instruction: {binary_instruction}")
        
    #     # Check for 32 bits
    #     if len(binary_instruction) != 32:
    #         print("LEN: ", len(binary_instruction))
    #         raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")

    #     # Convert binary instruction to hexadecimal
    #     machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex

    #     return machine_code

    def sbc_command(self, instruction_name, tokens, instruction):
        """
        Converts SBC R5, R4, R4, LSL #2 to binary.
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
        shift_amount = self.get_imm(shift_amount_str)  
        print("SHIFT AMT ", shift_amount)
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
        set_flags = self.get_set_flag(instruction_name)   

        # Shift amount (6 bits) and encode as binary
        shift_amount_binary = f"{shift_amount:05b}"  # 6 bits for shift amount
        print("SABIN ", shift_amount_binary)
        # Final binary instruction
        print("SHFT TYPE ", shift_type)
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{class_type}"
            f"{immediate_flag}"     # Immediate flag (1 bit)
            f"{opcode}"        # Opcode (4 bits, modify as per your opcode bit length)
            f"{set_flags}"          # Set flags (1 bit)
            f"{rn:04b}"             # First source register (4 bits)
            f"{rd:04b}"             # Destination register (4 bits)
            f"{shift_amount_binary}" # Shift amount (6 bits)
            f"{shift_type:02b}"         # Shift type (2 bits)
            f"0"
            f"{rm:04b}"             # Second source register (4 bits)
        )

        print(f"Binary instruction: {binary_instruction}")
        
        # Check for 32 bits
        if len(binary_instruction) != 32:
            print("LEN: ", len(binary_instruction))
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
        shift_amount = self.get_imm(shift_amount_str)  

        shift_type = self.shift_codes.get(shift_type_str)
        if shift_type is None:
            raise ValueError(f"Invalid shift type: {shift_type_str}")

        print(f"RD: {rd}, RN: {rn}, RM: {rm}, Shift Type: {shift_type}, Shift Amount: {shift_amount}")

        # Opcode for SUB
        opcode = self.opcode.get("ORR")
        print(f"Opcode for ORR: {opcode}")

        # Condition and flags
        condition = self.get_condition(instruction_name)
        immediate_flag = '0'  # Not using an immediate value
        class_type = '00'   # Data processing
        set_flags = self.get_set_flag(instruction_name)   

        # Shift amount (6 bits) and encode as binary
        shift_amount_binary = f"{shift_amount:05b}"  # 5 bits for shift amount
        
        # Final binary instruction  
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{class_type}"
            f"{immediate_flag}"     # Immediate flag (1 bit)
            f"{opcode}"        # Opcode (4 bits)
            f"{set_flags}"          # Set flags (1 bit)
            f"{rn:04b}"             # First source register (4 bits)
            f"{rd:04b}"             # Destination register (4 bits)
            f"{shift_amount_binary}" # Shift amount (5 bits)
            f"{shift_type:02b}"     # Shift type (2 bits) - convert to binary string
            f"0"
            f"{rm:04b}"             # Second source register (4 bits)
        )
        print(f"Binary instruction: {binary_instruction}")
        # Check for 32 bits
        if len(binary_instruction) != 32:
            print("LEN ", len(binary_instruction))
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")


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
        print(f"Opcode for AND: {opcode}")

        # Condition and flags
        condition = self.get_condition(instruction_name)
        immediate_flag = '0'    # Not using an immediate value
        set_flags = self.get_set_flag(instruction_name)   
        class_type = '00'        # Data processing

        # Final binary instruction
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{class_type}"
            f"{immediate_flag}"      # Immediate flag (1 bit)
            f"{opcode}"        # Opcode (6 bits)
            f"{set_flags}"          # Set flags (1 bit)
            f"{rn:04b}"             # First source register (4 bits)
            f"{rd:04b}"             # Destination register (4 bits)
            f"{rm:012b}"            # Second operand (12 bits) - need to ensure it's correctly formatted
        )
        print(f"Binary instruction: {binary_instruction}")

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
        immediate_flag = '0'     # Not using an immediate value
        set_flags = self.get_set_flag(instruction_name)   
        class_type = '00'        # Data processing

        # Final binary instruction
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{class_type}"     # Immediate flag (1 bit)
            f"{immediate_flag}"
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
        print(f"Binary instruction: {binary_instruction}")
        
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
        opcode = self.opcode.get("EOR")
        print(f"Opcode for EOR: {opcode}")
        # Condition and flags
        condition = self.get_condition(instruction_name)
        immediate_flag = '0'     # Not using an immediate value
        set_flags = self.get_set_flag(instruction_name)   
        class_type = '00'        # Data processing

        # Final binary instruction
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{class_type}"
            f"{immediate_flag}"
            f"{opcode}"        # Opcode (6 bits)  #opcode givin in arm website as 1111
            f"{set_flags}"          # Set flags (1 bit)
            f"{rn:04b}"             # First source register (4 bits)
            f"{rd:04b}"             # Destination register (4 bits)
            f"{rm:012b}"            # Second operand (12 bits) - need to ensure it's correctly formatted
        )
        print(f"Binary instruction: {binary_instruction}")
    
        if len(binary_instruction) != 32:
            print("LEN ", len(binary_instruction))
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")

        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex

        return machine_code
    
    def cmp_command(self, instruction_name, tokens, instructions):
        """
        Converts CMP R8, R6 to binary.
        or cmp R2, #20
        """
        immediate_encoded = None
        rd = 0
        rn = self.regcode.get(tokens[0].upper(), None)  # First register (R8)
        rm = None
        if re.match(r'R\d+', tokens[1].upper()):
            rm = self.regcode.get(tokens[1].upper(), None)  # Second register (R6)
        else:
            # Handle immediate value, expecting it to be in the format #value
            immediate_str = tokens[1].strip('#')
            immediate = self.get_imm(immediate_str)
            immediate_encoded = self.encode_immediate(immediate_value=immediate)
        
        print(f"TOKENS: {tokens}")
        print(f"RD: {rd}, RN: {rn}, RM: {rm}")
        print("IMMEDIATE ENCODED: ", immediate_encoded)
        # # Validate registers
        # if None in (rn, rm):
        #     raise ValueError("Invalid register")

        # Opcode for CMP
        opcode = self.opcode.get("CMP")  # CMP opcode in 4 bits

        # Condition and flags
        condition = self.get_condition(instruction_name)
        immediate_flag = 0  # Using registers (1 bit)
        if rm is None:
            immediate_flag = 1
        set_flags = '1'  # CMP sets flags
        class_type = '00'

        # Final binary instruction
        if rm is not None:
            binary_instruction = (
                f"{condition}"          # Condition (4 bits)
                f"{class_type}"
                f"{immediate_flag:01b}"     # Immediate flag (1 bit)
                f"{opcode}"             # Opcode (4 bits)
                f"{set_flags}"          # Set flags (1 bit)
                f"{rn:04b}"             # First register (4 bits)
                f"{rd:04b}"               # Rd is not used (4 bits)
                f"{rm:012b}"             # Second register (4 bits)
            )
        else:
            binary_instruction = (
                f"{condition}"          # Condition (4 bits)
                f"{class_type}"
                f"{immediate_flag:01b}"     # Immediate flag (1 bit)
                f"{opcode}"             # Opcode (4 bits)
                f"{set_flags}"          # Set flags (1 bit)
                f"{rn:04b}"             # First register (4 bits)
                f"{rd:04b}"               # Rd is not used (4 bits as 0000)
                f"{immediate_encoded}"             # Second register (4 bits)
            )

        # Check for 32 bits
        print("BIN ", binary_instruction)
        if len(binary_instruction) != 32:
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")
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
        opcode = self.opcode.get("TST")  # TST opcode in 4 bits

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
        print(f"Binary instruction: {binary_instruction}")
        # Check for 32 bits
        if len(binary_instruction) != 32:
            print("LEN ", len(binary_instruction))
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")

        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex

        return machine_code
    
    def str_register_command(self, instruction_name, tokens, instruction):
        """
        Converts STR R1, [R0, #0] to binary.
        """
        rt = self.regcode.get(tokens[0].upper(), None)  # Register to load (Rt)
        rn = self.regcode.get(tokens[1].upper().split(',')[0][1:], None)  # Base register (Rn)
        offset = int(tokens[2].split('#')[1][:-1])  # Immediate offset
        
        print(rt, rn, offset)
        
        condition = self.get_condition(instruction_name)
        immediate_flag_extended = '010'  # Using immediate (1 bit)
        P = '1'  # Post-indexed addressing (1)
        U = '1'  # Offset is added (1)
        W = '1'  # Writeback (1)
        set_flags = '0'
        
        imm12 = f"{offset:012b}"  # Convert offset to 12 bits
        
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{immediate_flag_extended}"     # Immediate flag (1 bit)
            f"{P}{U}0{W}"           # P, U, 1, W (4 bits)
            f"{set_flags}"          # Set flags (1 bit)
            f"{rn:04b}"             # Base register (Rn) (4 bits)
            f"{rt:04b}"             # Register to load (Rt) (4 bits)
            f"{imm12}"              # Immediate value (12 bits)
        )
        
        # Check for 32 bits
        if len(binary_instruction) != 32:
            print("LEN: ", len)
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")
        print("BINARY: ", binary_instruction)
        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex
        print("Machine code ",machine_code)
        
        return machine_code
    
    def str_command(self, instruction_name, tokens, instruction):
        """
        Converts STR R1, [R0], #0 to binary.
        now, new fun for STR R1, [R0, #0]
        
        """
        if '[' in tokens[1]:
            return self.str_register_command(instruction_name, tokens, instruction)
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

        print(f"Binary instruction: {binary_instruction}")
        # Check for 32 bits
        if len(binary_instruction) != 32:
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")

        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex

        return machine_code

    def ldr_literal_command(self, instruction_name, tokens, instruction):
        """
        Converts LDR R0, =temp1 to binary.
        """
        rt = self.regcode.get(tokens[0].upper(), None)  # Register to load (Rt)
        label = tokens[1].split('=')[1]
        #now find the address of the label
        address = self.symbol_table[label].value
        print(f"LABEL: {label}, ADDRESS: {address}")
        
        offset = address - self.current_address  # Calculate the offset
        print(f"OFFSET: {offset}")
        
        # The offset needs to be divided by 4 and fit in a 24-bit signed integer range
        offset >>= 2
        
        if offset < 0:
            offset = (1 << 12) + offset # Convert to 24-bit 2's complement for negative values
        
        # Mask the offset to ensure it's within 12 bits
        offset &= 0xFFF  # Mask to 12 bits
        print(f"OFFSET: {offset:012b}")
        
        condition = self.get_condition(instruction_name)
        immediate_flag_extended = '010' 
        P = '0'  # Post-indexed addressing (0)
        U = '1'  # Offset is added (1)
        W = '0'  # No writeback (0)
        set_flags = '1'
        
        # Immediate value must be in the range of 12 bits
        imm12 = f"{offset:012b}"  # Convert offset to 12 bits
        
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{immediate_flag_extended}"     # Immediate flag (3 bit)
            f"{P}{U}0{W}"           # P, U, 0, W (4 bits)
            f"{set_flags}"          # Set flags (1 bit)
            f"{self.regcode.get('PC'):04b}"  # Base register (Rn) (4 bits)
            f"{rt:04b}"             # Register to load (Rt) (4 bits)
            f"{imm12}"              # Immediate value (12 bits)
        )
        
        if len(binary_instruction) != 32:
            print("LEN: ", len)
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")

        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex
        print("MACHINE CODE: ", machine_code)
        return machine_code

    def ldr_register_command(self, instruction_name, tokens, instruction):
        """
        Converts LDR R0, [R7, #4] to binary.
        ['R0', '[R7', '#4]'] -> tokens array eg
        """
        # print("TOKENS ", tokens)
        # print("NUM:" ,tokens[2].split('#')[1][:-1])
        rt = self.regcode.get(tokens[0].upper(), None)  # Register to load (Rt)
        rn = self.regcode.get(tokens[1].upper().split(',')[0][1:], None)  # Base register (Rn)
        offset = int(tokens[2].split('#')[1][:-1])  # Immediate offset
        
        print(rt, rn, offset)
        
        condition = self.get_condition(instruction_name)
        immediate_flag_extended = '010'  # Using immediate (1 bit)
        P = '0'  # Post-indexed addressing (1)
        U = '1'  # Offset is added (1)
        W = '1'  # Writeback (1)
        set_flags = '1'
        
        imm12 = f"{offset:012b}"  # Convert offset to 12 bits
        
        binary_instruction = (
            f"{condition}"          # Condition (4 bits)
            f"{immediate_flag_extended}"     # Immediate flag (1 bit)
            f"{P}{U}0{W}"           # P, U, 1, W (4 bits)
            f"{set_flags}"          # Set flags (1 bit)
            f"{rn:04b}"             # Base register (Rn) (4 bits)
            f"{rt:04b}"             # Register to load (Rt) (4 bits)
            f"{imm12}"              # Immediate value (12 bits)
        )
        
        # Check for 32 bits
        if len(binary_instruction) != 32:
            print("LEN: ", len)
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")
        print("BINARY: ", binary_instruction)
        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"  # Convert binary to hex
        print("Machine code ",machine_code)
        
        return machine_code
        
    
    def ldr_command(self, instruction_name, tokens, instruction):
        """
        Converts LDR R11, [R0], #0 to binary.
        but if the assembly code has =, then it's a diff inst, like LDR R0, =temp1, so we'll call a diff fn
        diff fn for INST:  LDR R0, [R7, #4]
        """
        if '=' in tokens[1]:
            return self.ldr_literal_command(instruction_name, tokens, instruction)
        if '[' in tokens[1]:
            return self.ldr_register_command(instruction_name, tokens, instruction)
        rt = self.regcode.get(tokens[0].upper(), None)  # Register to load (Rt)
        rn = self.regcode.get(tokens[1].upper().split(',')[0], None)  # Base register (Rn)
        offset = "0"
        #if len of tokens is more than 2 then check for offset
        if len(tokens) > 2:
            offset = (tokens[2].split('#')[1]) if '#' in tokens[2] else "0"  # Immediate offset
        print("TOKEN1 ", tokens[1])
        print("BEFORE OFFSET ", offset)
        offset = self.get_imm(offset)
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
        print("IMM ", imm12)
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
    
    def branch_command(self, instruction_name, tokens, instruction):
        """
        Encodes the branch command.
        """
        base_instruction_name = instruction_name
        if len(instruction_name) > 3:
            base_instruction_name = instruction_name[:-2]  # to check if it's B or BL

        condition = '1110'  # Default to AL (Always) condition
        if len(instruction_name) > 2:
            condition = self.condition_codes.get(instruction_name[-2:])  
            print("CONDITOIN ", condition)
            
        is_link = 'L' in base_instruction_name.upper()  # If the base instruction contains 'L', it's BL
        opcode = '10'  # Base opcode for conditional branches
        link_bit = '1' if is_link else '0'  # Set the L bit based on BL or B
        
        # Get the immediate value or label offset
        offset = 0
        imm_bit = '0'
        if tokens[0].startswith('#'):
            imm_bit = '1'
            # Convert the immediate value to a signed 24-bit value (assuming it's in bytes)
            offset = self.get_imm(tokens[0][1:])  # Remove the '#' and convert to integer
        else:
            # If it's a label, calculate the offset (assuming label_address_map has the address)
            label = tokens[0]
            print("label ", label)
            print("st addx ", self.symbol_table[label].value)
            print("cur adx ", self.current_address)
            offset = self.symbol_table[label].value - self.current_address # as branch use relative offset
        print("OFFSET ", offset)
        # The offset needs to be divided by 4 and fit in a 24-bit signed integer range
        offset >>= 2  

        #check if it's neg
        if offset < 0:
            offset = (1 << 24) + offset  # Convert to 24-bit 2's complement for negative values

        # Mask the offset to ensure it's within 24 bits
        offset &= 0xFFFFFF  # Mask to 24 bits
        print("OFFSET ", f"{offset:024b}" )

        # Form the binary instruction: Condition (4 bits), Opcode (4 bits), L bit (1 bit), 24-bit offset
        binary_instruction = (
            f"{condition}"        # Condition (e.g., LT is 1011)
            f"{opcode}"       # Opcode for branch (10 for B)
            f"{imm_bit}"           # label (imm bit= 0)
            f"{link_bit}"         # L bit (1 for BL, 0 for B)
            f"{offset:024b}"      # 24-bit offset for branch target
        )
        
        print(f"Binary instruction: {binary_instruction}")
        # Check for 32 bits
        if len(binary_instruction) != 32:
            print("LEN ", len(binary_instruction))
            raise ValueError(f"Binary instruction is not 32 bits: {binary_instruction}")

        
        # Convert binary instruction to hexadecimal
        machine_code = f"{int(binary_instruction, 2):08X}"
        print(f"Machine code: {machine_code}")

        return machine_code


    def encode_instruction(self, instruction):
        tokens = self.tokenize_instruction(instruction)
        print("TOKENS: ", tokens)
        instruction_name = tokens[0].upper()
        print("INST NAME: ", instruction_name)
        if ".GLOBAL" == instruction_name:
            print("SETTING: ", tokens[1])
            self.symbol_table[tokens[1]].set_global()
        elif "MOV" in instruction_name:
            return self.mov_command(instruction_name, tokens[1:], instruction)
        elif "ADD" in instruction_name:
            return self.add_command(instruction_name, tokens[1:], instruction)
        elif "LDR" in instruction_name:
            return self.ldr_command(instruction_name, tokens[1:], instruction)
        elif "ADC" in instruction_name:
            return self.adc_command(instruction_name, tokens[1:], instruction)
        elif "SUB" in instruction_name:
            return self.sub_command(instruction_name, tokens[1:], instruction)
        elif "SBC" in instruction_name:
            return self.sbc_command(instruction_name, tokens[1:], instruction)
        elif "ORR" in instruction_name:
            return self.orr_command(instruction_name, tokens[1:], instruction)
        elif "AND" in instruction_name:
            return self.and_command(instruction_name, tokens[1:], instruction)
        elif "MVN" in instruction_name:
            return self.mvn_command(instruction_name, tokens[1:], instruction)
        elif "EOR" in instruction_name:
            return self.eor_command(instruction_name, tokens[1:], instruction)
        elif "CMP" in instruction_name:
            return self.cmp_command(instruction_name, tokens[1:], instruction)
        elif "TST" in instruction_name:
            return self.tst_command(instruction_name, tokens[1:], instruction)
        elif "STR" in instruction_name:
            return self.str_command(instruction_name, tokens[1:], instruction)
        elif "B" in instruction_name:
            return self.branch_command(instruction_name, tokens[1:], instruction)
        else:
            raise ValueError(f"Unknown instruction: {instruction}")

    def assemble(self, src_file_path):
        with open(src_file_path, 'r') as f:
            source_code = f.read()
            
        self.first_pass(source_code)
        self.second_pass()
        return self.machine_code

    def write_obj_file(self, machine_code, obj_file_path):
        with open(obj_file_path, "wb") as f:
             for instruction in machine_code:
                binary_data = bytes.fromhex(instruction)
                f.write(binary_data)


if __name__ == "__main__":
    assembler = Assembler()
    assembler.assemble("vmout.asm")
    # machine_code = assembler.assemble("vmout.asm")
    # print(f"Machine code: {machine_code}")
    
    # assembler.write_obj_file(machine_code, "asmout.obj")
    

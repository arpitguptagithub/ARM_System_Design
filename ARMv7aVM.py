
"""
## Arithmetic Commands
- `add<type>`
- `sub<type>`
- `and`
- `or`
- `not`
- `eq`
- `gt`
- `lt`

## Memory Access Commands (Stack to Segments)
- `push <segment> <offset>`
- `pop <segment> <offset>`

## Branching Commands (Program Flow)
- `label <symbol>`
- `goto <symbol>`
- `if-goto <symbol>`

## Function Commands
- `function <function_name> <number_of_locals>` (declaration)
- `call <function_name> <number_of_arguments>` (call)
- `return` (return from function)

"""


from Machines.ARMv7a_v3 import ARMv7
import re
class ARMv7aVMTranslator:#  just into ARMv7 for now will expand later

    def __init__(self):
        self.arm = ARMv7()
        self.label_counter = 0
        self.keep_comments = False  # Boolean switch to control comment handling
        self.label_signature = "temp_label_"
        self.is_multi_called=False
        self.is_divi_called=False
        

    def translate(self, vm_code):
        asm_code = []
        cleaned_code = self.clean_comments(vm_code)
        
        # print("cleaned code:\n", cleaned_code, "\n", "*" * 30)
        variable_table, function_table, vm_instructions = self.extract_symbol_table(cleaned_code)
        self.arm.variable_table = variable_table
        # print("extracted variable table: ",variable_table)
        self.arm.function_table = function_table
        # Check for multi and divi instructions
        if 'muli' in vm_instructions:
            self.is_multi_called = True
        if 'divi' in vm_instructions:
            self.is_divi_called = True
        #print("vm instructions are :",vm_instructions)
        # Prepass to capture function details
        self.capture_function_signatures(vm_instructions)
        
        # Add initialization code
       
        # asm_code.append(self.generate_symbol_table_str())
        asm_code.extend(self.initialize())
        
        
        for line in vm_instructions.split('\n'):
            line = line.strip()
            if line:  # Check if there's any code left after removing comments
                asm_code.extend(self.translate_instruction(line))
        return '\n'.join(asm_code)
    def generate_symbol_table_str(self):
        symbol_table_str = "Symboltable:\n"
        
        
        # Generate symbol table section
        # symbol_table_str += "  Variable:\n"
        # for name, info in self.arm.variable_table.items():
        #     symbol_table_str += f"    {name} {info['size']} {info['defined']}\n"
        symbol_table_str += "  Function:\n" 
        for name, info in self.arm.function_table.items():
            symbol_table_str += f"    {name} {info['num_locals']} {info['defined']}\n"
                
        return symbol_table_str
    def extract_symbol_table(self, vm_code):
        variable_table = {}
        function_table = {}
        vm_instructions = ""

        # Extract symbol table
        symbol_table_match = re.search(r"Symboltable:\s*([\s\S]*?)\s*glob_init", vm_code)
        if symbol_table_match:
            symbol_table = symbol_table_match.group(1)

            # Extract variables
            variables_match = re.search(r"Variable:\s*([\s\S]*?)(?=\s*Function:|$)", symbol_table)
            if variables_match:
                variables = variables_match.group(1).strip().split('\n')
                for line in variables:
                    line = line.strip()
                    if line and not line.startswith('//'):
                        parts = line.split()
                        if len(parts) == 3:
                            # print("parts are ",parts)
                            name, size, defined = parts
                            variable_table[name] = {"size": int(size), "defined": int(defined)}

            # Extract functions
            functions_match = re.search(r"Function:\s*([\s\S]*?)(?=\s*$)", symbol_table)
            if functions_match:
                functions = functions_match.group(1).strip().split('\n')
                for line in functions:
                    line = line.strip()
                    if line and not line.startswith('//'):
                        parts = line.split()
                        if len(parts) == 3:
                            name, size, defined = parts
                            function_table[name] = {"num_locals": int(size), "defined": int(defined)}
        # Extract VM instructions
        vm_instructions_match = re.search(r"label\s+glob_init\s*([\s\S]*?)$", vm_code)
        if vm_instructions_match:
            vm_instructions = vm_code[vm_instructions_match.start(1):].strip()

        return variable_table, function_table, vm_instructions
    def initialize(self):
        
        cumulative_size = sum(info['size'] for info in self.arm.variable_table.values())
        init_code = [
            f"MOV {self.arm.base_address}, pc", # TODO: uncomment to make work in pipeline
            "MOV R6, #0x100", 
            f"ADD R6, R6, #{cumulative_size*4}",  # Initialize the stack pointer
            "ADD R4, R6,#64",
            "ADD R5, R4,#0",
            "ADD R7, R4, #0",
            f""
            # "B main"             # Branch to main function
        ]
        
        #after initializing the pointers keep the setup code for call main #args
        target_var="main"
        arg_size = self.arm.function_table[target_var]['size'] if target_var in self.arm.variable_table else 0 
        setup_return_label="end"
        setup_code = [
             f"LDR R0, ={setup_return_label}",
            f"STR R0, [{self.arm.compute_stack_ptr},#0]",
            f"ADD {self.arm.compute_stack_ptr}, {self.arm.compute_stack_ptr}, #4",
            
            # Save frame pointers (LCL, ARG)
            f"STR {self.arm.local_stack_ptr}, [{self.arm.compute_stack_ptr},#0]",
            f"ADD {self.arm.compute_stack_ptr}, {self.arm.compute_stack_ptr}, #4",
            f"STR {self.arm.argument_stack_ptr}, [{self.arm.compute_stack_ptr},#0]",
            f"ADD {self.arm.compute_stack_ptr}, {self.arm.compute_stack_ptr}, #4",
            
            # Set new LCL
            # f"MOV {self.local_stack_ptr}, {self.compute_stack_ptr}",
            f"ADD {self.arm.local_stack_ptr}, {self.arm.compute_stack_ptr}, #0",
            
            # Set new ARG
            f"SUB {self.arm.argument_stack_ptr}, {self.arm.compute_stack_ptr}, #{4 * (int(arg_size) + 3)}",
            f""
            # f"B {function_name}",
           
            # f"{return_label}:"
            #assuming the above two lines will be automatically be translated from vm to .asm
        ]

        if self.is_multi_called:
            init_code.extend(self.get_multiplication_custom())
        if self.is_divi_called:
            init_code.extend(self.get_division_custom())
        return init_code
    
    def get_new_label(self):
        self.label_counter += 1
        return f"{self.label_signature}{self.label_counter}"
    def get_division_custom(self):
        positive_division_label = self.get_new_label()
        division_loop_label = self.get_new_label()
        end_division_label = self.get_new_label()
        negate_division_result_label = self.get_new_label()
        
        return [
                "B end_div_label",
                "divi:",                                     # Function label
                f"LDR R0, [R5,#0]",                        # Load the first argument from arg[0]
                f"LDR R1, [R5,#4]",                        # Load the second argument from arg[1]
                "MOV R2, #0",                              # Initialize R2 to 0 (quotient)
                "MOV R3, #0",                              # Initialize R3 to 0 (positive result)
                "CMP R0, #0",                              # Compare R0 with 0
                f"BGE {positive_division_label}",          # If R0 >= 0, branch to positive_division_label
                "SUB R3, R3, #1",                          # R3 = -1 (indicate negative result)
                "MOV R8, #0",                              # Temporary register R8
                "SUB R8, R8, R0",                          # R8 = -R0 (make R0 positive)
                "ADD R0, R8,#0",                              # Move R8 to R0
                f"{positive_division_label}:",             # Positive division label
                "CMP R1, #0",                              # Compare R1 with 0
                f"BGE {division_loop_label}",              # If R1 >= 0, branch to division_loop_label
                "ADD R3, R3, #1",                          # Flip the sign of R3
                "MOV R8, #0",                              # Temporary register R8
                "SUB R8, R8, R1",                          # R8 = -R1 (make R1 positive)
                "ADD R1, R8,#0",                              # Move R8 to R1
                f"{division_loop_label}:",                 # Division loop label
                "CMP R0, R1",                              # Compare R0 with R1
                f"BLT {end_division_label}",               # If R0 < R1, branch to end_division_label
                "SUB R0, R0, R1",                          # Subtract R1 from R0
                "ADD R2, R2, #1",                          # Increment R2 (quotient)
                f"B {division_loop_label}",                # Branch to division_loop_label
                f"{end_division_label}:",                  # End division label
                "CMP R3, #0",                              # Compare R3 with 0
                f"BGE {negate_division_result_label}",     # If R3 >= 0, branch to negate_division_result_label
                "MOV R8, #0",                              # Temporary register R8
                "SUB R8, R8, R2",                          # R8 = -R2 (negate the result)
                "ADD R2, R8,#0",                              # Move R8 to R2
                f"{negate_division_result_label}:",        # Negate division result label
                "ADD R0, R2,#0",                              # Move the result to R0
                
                 #the below code is of the return function call handler
                f"STR R0, [R5,#0]",
                f"ADD R1, R5, #4",# this is sp of caller
                
                f"SUB R7,R4, #4",
                
                f"LDR R5, [R7,#0]",
                f"SUB R7, R7, #4",
                
                f"LDR R4, [R7,#0]",
                f"SUB R7, R7, #4",
                f"LDR R0, [R7,#0]",

                f"ADD R7, R1,#0",
                "ADD PC, R0,#0",
                f"end_div_label:",
        ]
    def get_multiplication_custom(self):
        loop_label = self.get_new_label()
        end_label = self.get_new_label()
        negate_r3_label = self.get_new_label()
        negate_result_label = self.get_new_label()
        positive_multiplication_label = self.get_new_label()
        return [
                f"B end_mul_label",
                "multi:",                                   # Function label
                
                f"LDR R0, [R5,#0]",                        # Load the first argument from arg[0]
                f"LDR R1, [R5,#4]",                        # Load the second argument from arg[1]
                "MOV R2, #0",  
                "MOV R3, #0",                               # Initialize R3 to 0 (positive result)
                "CMP R0, #0",                               # Compare R0 with 0
                f"BGE {positive_multiplication_label}",     # If R0 >= 0, branch to positive_multiplication_label
                "SUB R3, R3, #1",                           # R3 = -1 (indicate negative result)
                "MOV R8, #0",                               # Temporary register R8
                "SUB R8, R8, R0",                           # R8 = -R0 (make R0 positive)
                "ADD R0, R8,#0",                               # Move R8 to R0
                f"{positive_multiplication_label}:",        # Positive multiplication label
                "CMP R1, #0",                               # Compare R1 with 0
                f"BGE {loop_label}",                        # If R1 >= 0, branch to loop_label
                "ADD R3, R3, #1",                           # Flip the sign of R3
                "MOV R8, #0",                               # Temporary register R8
                "SUB R8, R8, R1",                           # R8 = -R1 (make R1 positive)
                "ADD R1, R8,#0",                               # Move R8 to R1
                f"{loop_label}:",                           # Loop label
                                             # Initialize the result register R2 to 0
                "CMP R0, #0",                               # Compare R0 with 0
                f"BEQ {end_label}",                         # If R0 == 0, branch to end_label
                "ADD R2, R2, R1",                           # Add R1 to R2
                "SUB R0, R0, #1",                           # Decrement R0 by 1
                f"B {loop_label}",                          # Branch to loop_label
                f"{end_label}:",                            # End label
                "CMP R3, #0",                               # Compare R3 with 0
                f"BGE {negate_result_label}",               # If R3 >= 0, branch to negate_result_label
                "MOV R8, #0",                               # Temporary register R8
                "SUB R8, R8, R2",                           # R8 = -R2 (negate the result)
                "ADD R2, R8,#0",                               # Move R8 to R2
                f"{negate_result_label}:",                  # Negate result label
                "ADD R0, R2,#0",                              # Move the result to R0
            
            #the below code is of the return function call handler
                f"STR R0, [R5,#0]",
                f"ADD R1, R5, #4",# this is sp of caller
                
                f"SUB R7,R4, #4",
                
                f"LDR R5, [R7,#0]",
                f"SUB R7, R7, #4",
                
                f"LDR R4, [R7,#0]",
                f"SUB R7, R7, #4",
                f"LDR R0, [R7,#0]",

                f"ADD R7, R1,#0",
                f"ADD PC, R0,#0",
                f"end_mul_label:",
                
                
                ]

    def clean_comments(self, vm_code):
        cleaned_lines = []
        in_multiline_comment = False
        for line in vm_code.split('\n'):
            cleaned_line = ''
            i = 0
            while i < len(line):
                if in_multiline_comment:
                    if line[i:i+2] == '*/':
                        in_multiline_comment = False
                        i += 2
                    else:
                        i += 1
                elif line[i:i+2] == '//':
                    break
                elif line[i:i+2] == '/*':
                    in_multiline_comment = True
                    i += 2
                else:
                    cleaned_line += line[i]
                    i += 1
            if cleaned_line.strip():
                cleaned_lines.append(cleaned_line.strip())
        return '\n'.join(cleaned_lines)

    def capture_function_signatures(self, cleaned_code):
        for line in cleaned_code.split('\n'):
           #print("lined code is ",line)
            parts = line.strip().split()
            if parts[0] == "function":
                function_name = parts[1]
                num_locals = int(parts[2])
                self.arm.function_signatures[function_name] = {
                    "num_locals": num_locals,
                    "num_args": 0  # We'll update this when we see a 'call' instruction
                }
            elif parts[0] == "call":
                function_name = parts[1]
                num_args = int(parts[2])
                if function_name in self.arm.function_signatures:
                    self.arm.function_signatures[function_name]["num_args"] = num_args
                else:
                    self.arm.function_signatures[function_name] = {
                        "num_locals": 0,  # We don't know this yet
                        "num_args": num_args
                    }

    def translate_instruction(self, instruction):
        parts = instruction.strip().split()
        if len(parts) == 0:
            return []
        command = parts[0]
        if command not in ["addi", "subi", "muli",
                           "addf", "subf", "mulf",
                           "and", "or", "not",
                           "eq", "gt", "lt",
                           "push", "pop", "label",
                           "goto", "if-goto", "function",
                           "call", "return", "wmem", "rmem","divi"]:
            print("unknown: ",command)
            pass
        else:
            temp = self.arm.execute(command, *parts[1:])
            print(instruction,"\n",temp,"\n","*"*30)
            return temp

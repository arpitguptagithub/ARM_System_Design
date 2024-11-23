"""
ARM instructions:
'MOV': self.mov,    # Move (input: dest, src; op: dest = src)
'ADD': self.add,    # Add (input: dest, src1, src2; op: dest = src1 + src2)
'ADDS': self.adds,  # Add and Set flags (input: dest, src1, src2; op: dest = src1 + src2, set flags)
'ADC': self.adc,    # Add with Carry (input: dest, src1, src2; op: dest = src1 + src2 + carry)
'SUB': self.sub,    # Subtract (input: dest, src1, src2; op: dest = src1 - src2)
'SBC': self.sbc,    # Subtract with Carry (input: dest, src1, src2; op: dest = src1 - src2 - carry)
'ORR': self.orr,    # Bitwise OR (input: dest, src1, src2; op: dest = src1 | src2)
'AND': self.and_op, # Bitwise AND (input: dest, src1, src2; op: dest = src1 & src2)
'MVN': self.mvn,    # Move Not (Bitwise NOT) (input: dest, src; op: dest = ~src)
'EOR': self.eor,    # Bitwise XOR (input: dest, src1, src2; op: dest = src1 ^ src2)
'CMP': self.cmp,    # Compare (input: src1, src2; op: set flags based on src1 - src2)
'ADDNE': self.addne,# Add if Not Equal (input: dest, src1, src2; op: if(Z) dest = src1 + src2)
'TST': self.tst,    # Test bits (input: src1, src2; op: set flags based on src1 & src2)
'ADDEQ': self.addeq,# Add if Equal (input: dest, src1, src2; op: if(Z) dest = src1 + src2)
'STR': self.str,    # Store Register (input: src, dest; op: memory[dest] = src)
'LDR': self.ldr,    # Load Register (input: dest, src; op: dest = memory[src])
'STRGT': self.strgt,# Store Register if Greater Than (input: src, dest; op: if(GT) memory[dest] = src)
'BLT': self.blt,    # Branch if Less Than (input: label; op: if(LT) PC = label)
'B': self.b         # Branch (input: label; op: PC = label)

VMcode 
"addi", "subi", "muli", "addf", "subf", "mulf", "and", "or", "not", "eq", "gt", "lt", "push", "pop", "label", "goto", "if-goto", "function", "call", "return"
, "wmem", "rmem".

fn call -handling:
- function:
    - save return address
    - save current pointers.
    - update local stack pointer
    - update argument stack pointer
    - update temp stack pointer
    - goto function start label

-fn declaration handling:
    function fname numlocals:
         -verify in python signatures
         -repeat k times:push 0 to compute stack

- return handling:
    - pop return address
    - restore current pointers.
    - save return value in top of compute stack
    - goto return address
"""
# TODO : save function signatures: num input args, {always 1 output arg returns in arg 0}, num local variables{variables are to be in 4bytes}
class ARMv7:
    def __init__(self):
        self.registers = ['R0', 'R1', 'R2', 'R3', 'R4', 'R5', 'R6', 'R7', 'R8', 'R9', 'R10', 'R11', 'R12', 'SP', 'LR', 'PC']
        self.local_stack_ptr = "R4"
        self.argument_stack_ptr = "R5"
        self.temp_stack_ptr = "R6"
        self.compute_stack_ptr = "R7"
        self.base_address = "R8"
        # above registers are the pointers.
        self.function_signatures = {}
        self.label_counter = 15
        self.label_signature = "temp_label_"
        self.variable_table = {}
        self.function_table = {}
        
    def execute(self, instruction, *args):
        if instruction == "addi":
            return self.handle_addi(*args)
        elif instruction == "subi":
            return self.handle_subi(*args)
        elif instruction == "muli":
            return self.handle_muli(*args)
        elif instruction == "divi":
            return self.handle_divi(*args)
        elif instruction == "addf":
            return self.handle_addf(*args)
        elif instruction == "subf":
            return self.handle_subf(*args)
        elif instruction == "mulf":
            return self.handle_mulf(*args)
        elif instruction == "and":
            return self.handle_and(*args)
        elif instruction == "or":
            return self.handle_or(*args)
        elif instruction == "not":
            return self.handle_not(*args)
        elif instruction == "eq":
            return self.handle_eq(*args)
        elif instruction == "gt":
            return self.handle_gt(*args)
        elif instruction == "lt":
            return self.handle_lt(*args)
        elif instruction == "push":
            return self.handle_push(*args)
        elif instruction == "pop":
            return self.handle_pop(*args)
        elif instruction == "label":
            return self.handle_label(*args)
        elif instruction == "goto":
            return self.handle_goto(*args)
        elif instruction == "if-goto":
            return self.handle_if_goto(*args)
        elif instruction == "function":
            return self.handle_function(*args)
        elif instruction == "call":
            return self.handle_call(*args)
        elif instruction == "return":
            return self.handle_return(*args)
        elif instruction == "wmem":
            return self.handle_wmem(*args)
        elif instruction == "rmem":
            return self.handle_rmem(*args)
        else:
            raise ValueError(f"Invalid instruction: {instruction}")
        
    def get_new_label(self):
        self.label_counter += 1
        return f"{self.label_signature}{self.label_counter}"

    def handle_addi(self):
        return [
            # f"LDR R0, [{self.compute_stack_ptr}, #-4]",
            f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #4",
            f"LDR R0, [R2 , #0]",
            
            # f"LDR R1, [{self.compute_stack_ptr}, #-8]",
             f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #8",
            f"LDR R1, [R2 , #0]",
            
            "ADD R0, R1, R0",
            
            #f"STR R0, [{self.compute_stack_ptr}, #-8]",
            f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #8",
            f"STR R0, [R2,#0]",
            
            f"SUB {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4"
        ]

    def handle_subi(self, *args):
        return [
            #f"LDR R0, [{self.compute_stack_ptr}, #-4]",
             f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #4",
            f"LDR R0, [R2, #0]",
            
           # f"LDR R1, [{self.compute_stack_ptr}, #-8]",
            f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #8",
            f"LDR R1, [R2, #0]",
            
            "SUB R0, R1, R0",
            
            #f"STR R0, [{self.compute_stack_ptr}, #-8]",
             f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #8",
            f"STR R0, [R2,#0]",
            
            f"SUB {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4"
        ]

    # def handle_muli(self, *args):
    #     loop_label = self.get_new_label()
    #     end_label = self.get_new_label()
    #     # return [
    #     #     f"LDR R0, [{self.compute_stack_ptr}, #-4]",
    #     #     f"LDR R1, [{self.compute_stack_ptr}, #-8]",
    #     #     "MOV R2, #0",
    #     #     "CMP R0, #0",
    #     #     f"BLT {end_label}",
    #     #     f"{loop_label}:",
    #     #     "ADD R2, R2, R1",
    #     #     "SUB R0, R0, #1",
    #     #     "CMP R0, #0",
    #     #     f"BGE {loop_label}",
    #     #     f"{end_label}:",
    #     #     f"STR R2, [{self.compute_stack_ptr}, #-8]",
    #     #     f"SUB {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4"
    #     # ]
    #     return [
    #         f"LDR R0, [{self.compute_stack_ptr}, #-4]",
    #         f"LDR R1, [{self.compute_stack_ptr}, #-8]",
    #         "MUL R0, R1, R0",
    #         f"STR R0, [{self.compute_stack_ptr}, #-8]",
    #         f"SUB {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4"
    #     ]
    def handle_muli(self,*args):
        assembly_code = []
        assembly_code.extend(self.handle_call("multi", 2))
        return assembly_code
    def handle_divi(self,*args):
        # print("in the divsion")
        assembly_code = []
        assembly_code.extend(self.handle_call("divi", 2))
        return assembly_code

    def handle_addf(self, *args):
        # Floating point operations are not supported with given instructions
        return []

    def handle_subf(self):
        # Floating point operations are not supported with given instructions
        return []

    def handle_mulf(self):
        # Floating point operations are not supported with given instructions
        return []

    def handle_and(self):
        return [
           # f"LDR R0, [{self.compute_stack_ptr}, #-4]",
            f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #4",
            f"LDR R0, [R2,#0]",
            
            #f"LDR R1, [{self.compute_stack_ptr}, #-8]",
             f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #8",
            f"LDR R1, [R2,#0]",
            
            "AND R0, R1, R0",
            #f"STR R0, [{self.compute_stack_ptr}, #-8]",
            f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #8",
            f"STR R0, [R2,#0]",
        
            f"SUB {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4"
        ]

    def handle_or(self):
        return [
            #f"LDR R0, [{self.compute_stack_ptr}, #-4]",
            f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #4",
            f"LDR R0, [R2,#0]",
            
            #f"LDR R1, [{self.compute_stack_ptr}, #-8]",
            f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #8",
            f"LDR R1, [R2,#0]",
            
            "ORR R0, R1, R0",
            #f"STR R0, [{self.compute_stack_ptr}, #-8]",
            f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #8",
            f"STR R0, [R2,#0]",
            
            f"SUB {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4"
        ]

    def handle_not(self):
        return [
            #f"LDR R0, [{self.compute_stack_ptr}, #-4]",
            f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #4",
            f"LDR R0, [R2,#0]",
            
            "MVN R0, R0",
            #f"STR R0, [{self.compute_stack_ptr}, #-4]"
            f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #4",
            f"STR R0, [R2,#0]",
        ]

    def handle_eq(self):#comparison has no popping.
        true_label = self.get_new_label()
        end_label = self.get_new_label()
        return [
            #f"LDR R0, [{self.compute_stack_ptr}, #-4]",
            f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #4",
            f"LDR R0, [R2,#0]",
            
            #f"LDR R1, [{self.compute_stack_ptr}, #-8]",
            f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #8",
            f"LDR R1, [R2,#0]",
            
            "CMP R1, R0",
            f"BEQ {true_label}",
            "MOV R0, #0",
            f"B {end_label}",
            f"{true_label}:",
            "MOV R0, #1",
            f"{end_label}:",
            f"STR R0, [{self.compute_stack_ptr}]",
            # f"SUB {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4"
            f"ADD {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4"	

        ]

    def handle_gt(self):
        true_label = self.get_new_label()
        end_label = self.get_new_label()
        return [
            #f"LDR R0, [{self.compute_stack_ptr}, #-4]",
            f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #4",
            f"LDR R0, [R2,#0]",
            
            #f"LDR R1, [{self.compute_stack_ptr}, #-8]",
            f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #8",
            f"LDR R1, [R2,#0]",
            
            "CMP R1, R0",
            f"BGT {true_label}",
            "MOV R0, #0",
            f"B {end_label}",
            f"{true_label}:",
            "MOV R0, #1",
            f"{end_label}:",
            f"STR R0, [{self.compute_stack_ptr},#0]",
            # f"SUB {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4"
            f"ADD {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4"	

        ]

    def handle_lt(self):
        true_label = self.get_new_label()
        end_label = self.get_new_label()
        return [
            #f"LDR R0, [{self.compute_stack_ptr}, #-4]",
            f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #4",
            f"LDR R0, [R2,#0]",
            
           # f"LDR R1, [{self.compute_stack_ptr}, #-8]",
           f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #8",
            f"LDR R1, [R2,#0]",
            
            "CMP R1, R0",
            f"BLT {true_label}",
            "MOV R0, #0",
            f"B {end_label}",
            f"{true_label}:",
            "MOV R0, #1",
            f"{end_label}:",
            f"STR R0, [{self.compute_stack_ptr},#0]",
            # f"SUB {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4"
            f"ADD {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4"	
        ]
    
    def handle_push(self, segment, offset=0):
        # computestackptr ++
        # based on segment and offset do the op
        # can handle any restrictions seperately
        temp=[]
        
        if segment != "static":
            offset = int(offset) * 4
        if segment == "static":
            
            if offset=="lcl":
                temp = [
                f"ADD R0, {self.local_stack_ptr}, #0",
                f"STR R0, [{self.compute_stack_ptr},#0]",
                
                ]
            
            elif offset=="arg":
                temp = [
                f"ADD R0, {self.argument_stack_ptr}, #0",
                f"STR R0, [{self.compute_stack_ptr},#0]",
                
                # f"LDR R1, [{self.compute_stack_ptr},#0]",
                
                ]
            elif offset=="temp":    
                temp = [
                f"ADD R0, {self.temp_stack_ptr}, #0",
                f"STR R0, [{self.compute_stack_ptr},#0]",
                
                # f"LDR R1, [{self.compute_stack_ptr},#0]",
                
                ]
            else:
                
            #idx = list(self.variable_table.keys()).index(offset) if offset in self.variable_table else None
                keys = list(self.variable_table.keys())
                target_index = keys.index(offset)  # Find the index of the target variable
                cumulative_size = sum(self.variable_table[keys[i]]['size'] for i in range(target_index + 1))
            
                if cumulative_size is None:
                    raise ValueError(f"Unknown variable: {offset}")
                # print("static is called")
                temp = [
                # f"ADD R0, {self.temp_stack_ptr}, #-{idx * 4}",
                f"ADD R2,{self.temp_stack_ptr}, #0",
                f"SUB R2, R2, #{cumulative_size}",
                f"ADD R0, R2, #0",
            
                f"STR R0, [{self.compute_stack_ptr},#0]"
                ]
        elif segment == "constant":
            temp = [
                f"MOV R0, #{int(offset/4)}",
                f"STR R0, [{self.compute_stack_ptr},#0]",
            ]
        elif segment == "local":
            temp = [
                f"ADD R0, {self.local_stack_ptr}, #{offset}",
                f"LDR R1, [R0,#0]",
                f"STR R1, [{self.compute_stack_ptr},#0]"
            ]
        elif segment == "argument":
            temp = [
                f"ADD R0, {self.argument_stack_ptr}, #{offset}",
                f"LDR R1, [R0,#0]",
                f"STR R1, [{self.compute_stack_ptr},#0]"
            ]
        elif segment == "temp":
            temp = [
                f"ADD R0, {self.temp_stack_ptr}, #{offset}",
                f"LDR R1, [R0,#0]",
                f"STR R1, [{self.compute_stack_ptr},#0]"
            ]
        else:
            raise ValueError(f"Unknown segment: {segment}")
        temp.append(f"ADD {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4")# incrementing sp 
        return temp

    def handle_pop(self, segment, offset=0):
        # based on segment and offset do the op
        offset = int(offset)*4

        temp = []
        if segment == "local":
            temp.extend([
                # f"LDR R0, [{self.compute_stack_ptr}, #-4]",
                f"ADD R2,{self.compute_stack_ptr}, #0",
                f"SUB R2, R2, #4",
                f"LDR R0, [R2,#0]",
            
                f"ADD R1, {self.local_stack_ptr}, #{offset}",
                f"STR R0, [R1,#0]"
            ])
        elif segment == "argument":
            temp.extend([
                # f"LDR R0, [{self.compute_stack_ptr}, #-4]",
                f"ADD R2,{self.compute_stack_ptr}, #0",
                f"SUB R2, R2, #4",
                f"LDR R0, [R2,#0]",
            
                f"ADD R1, {self.argument_stack_ptr}, #{offset}",
                f"STR R0, [R1,#0]"
            ])
        elif segment == "temp":
            temp.extend([
                # f"LDR R0, [{self.compute_stack_ptr}, #-4]",
                f"ADD R2,{self.compute_stack_ptr}, #0",
                f"SUB R2, R2, #4",
                f"LDR R0, [R2,#0]",
                
                f"ADD R1, {self.temp_stack_ptr}, #{offset}",
                f"STR R0, [R1,#0]"
            ])
            
        else:
            raise ValueError(f"Unknown segment: {segment}")
        temp.append(f"SUB {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4")  # decrementing sp
        return temp

    def handle_wmem(self,segment,offset=0):
        offset = int(offset)*4
        
        temp = []# equivalent to pop and store in memory
        if segment == "local":
            temp.extend([
                # f"LDR R0, [{self.compute_stack_ptr}, #-4]",
                f"ADD R2,{self.compute_stack_ptr}, #0",
                f"SUB R2, R2, #4",
                f"LDR R0, [R2,#0]",
                
                f"ADD R1, {self.local_stack_ptr}, #{offset}",
                f"STR R0, [R1,#0]"
            ])
        elif segment == "argument":
            temp.extend([
                # f"LDR R0, [{self.compute_stack_ptr}, #-4]",
                f"ADD R2,{self.compute_stack_ptr}, #0",
                f"SUB R2, R2, #4",
                f"LDR R0, [R2,#0]",
                
                f"ADD R1, {self.argument_stack_ptr}, #{offset}",
                f"STR R0, [R1,#0]"
            ])
        elif segment == "temp":
            temp.extend([
                # f"LDR R0, [{self.compute_stack_ptr}, #-4]",
                f"ADD R2,{self.compute_stack_ptr}, #0",
                f"SUB R2, R2, #4",
                f"LDR R0, [R2,#0]",
                
                f"ADD R1, {self.temp_stack_ptr}, #{offset}",
                f"STR R0, [R1,#0]"
            ])
        elif segment == "constant":
            temp.extend([
                # f"LDR R0, [{self.compute_stack_ptr}, #-4]",
                f"ADD R2,{self.compute_stack_ptr}, #0",
                f"SUB R2, R2, #4",
                f"LDR R0, [R2,#0]",
                
                f"MOV R1, #{int(offset/4)}",
                f"STR R0, [R1,#0]"
            ])
        else:
            raise ValueError(f"Unknown segment: {segment}")
        temp.append(f"SUB {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4")  # decrementing sp
        return temp
    
    def handle_rmem(self,segment,offset=0):
        offset = int(offset)*4
        temp = []# equivalent to read from memory and push to stack
        
        if segment == "local":
            temp.extend([
                f"ADD R0, {self.local_stack_ptr}, #{offset}",
                f"LDR R0, [R0,#0]",
                f"LDR R1, [R0,#0]",
                f"STR R1, [{self.compute_stack_ptr},#0]"
            ])
        elif segment == "argument":
            temp.extend([
                f"ADD R0, {self.argument_stack_ptr}, #{offset}",
                f"LDR R0, [R0,#0]",
                f"LDR R1, [R0,#0]",
                
                f"STR R1, [{self.compute_stack_ptr},#0]"
            ])
        elif segment == "temp":
            temp.extend([
                f"ADD R0, {self.temp_stack_ptr}, #{offset}",
                f"LDR R0, [R0,#0]",
                f"LDR R1, [R0,#0]",
                
                f"STR R1, [{self.compute_stack_ptr},#0]"
            ])
        else:
            raise ValueError(f"Unknown segment: {segment}")
        temp.append(f"ADD {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4")  # incrementing sp
        return temp


# fn data needed.
    def handle_label(self,label):
        return [
            f"{label}:",
        ]

    def handle_goto(self,label):
        return [
            f"B {label}"
        ]

    def handle_if_goto(self,label):
        return [
            # f"LDR R0, [{self.compute_stack_ptr}, #-4]",
            f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #4",
            f"LDR R0, [R2,#0]",
                
            "CMP R0, #1",
            f"SUB {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4",
            f"BEQ {label}",
        ]
    

    def handle_return(self):
        """
        put top of compute stack to arg0
        
        set cp to lcl
        save old arg ptr
        pop to get arg ptr old
        pop to get lcl ptr old
        pop to get return address
        set stack ptr to arg ptr 
        use return address to jump to return address
        """
        return [
            # Pop return value
            # f"LDR R0, [{self.compute_stack_ptr}, #-4]",
            f"ADD R2,{self.compute_stack_ptr}, #0",
            f"SUB R2, R2, #4",
            f"LDR R0, [R2,#0]",
                
            f"STR R0, [{self.argument_stack_ptr},#0]",
            f"ADD R1, {self.argument_stack_ptr}, #4",# this is sp of caller
            
            f"SUB {self.compute_stack_ptr}, {self.local_stack_ptr}, #4",
            
            f"LDR {self.argument_stack_ptr}, [{self.compute_stack_ptr},#0]",
            f"SUB {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4",
            
            f"LDR {self.local_stack_ptr}, [{self.compute_stack_ptr},#0]",
            f"SUB {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4",
            f"LDR R0, [{self.compute_stack_ptr},#0]",

            # f"MOV {self.compute_stack_ptr}, R1",
            f"ADD {self.compute_stack_ptr}, R1, #0",
            
            # "MOV PC, R0"
            f"ADD PC, R0, #0"
        ]
    def handle_call(self, function_name, num_args):
        """
        
        """
        return_label = self.get_new_label()
        return [
            # Save return address
            #the below is the newly added code inroder to handler args 0 case
            f"ADD {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4",
            
            
            f"LDR R0, ={return_label}",
            # f"ADD R0, R0, {self.base_address}", # TODO: uncomment to make work in pipeline
            f"STR R0, [{self.compute_stack_ptr},#0]",
            f"ADD {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4",
            
            # Save frame pointers (LCL, ARG)
            f"STR {self.local_stack_ptr}, [{self.compute_stack_ptr},#0]",
            f"ADD {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4",
            f"STR {self.argument_stack_ptr}, [{self.compute_stack_ptr},#0]",
            f"ADD {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4",
            
            # Set new LCL
            # f"MOV {self.local_stack_ptr}, {self.compute_stack_ptr}",
            f"ADD {self.local_stack_ptr}, {self.compute_stack_ptr}, #0",
            
            # Set new ARG
            f"SUB {self.argument_stack_ptr}, {self.compute_stack_ptr}, #{4 * (int(num_args)+1 + 3)}",
            
            f"B {function_name}",
            # Return label
            f"{return_label}:"
        ]
        
    def handle_function(self, function_name, num_locals):
        """
        Function declaration handling:
        1. Create label for function entry
        2. Initialize local variables to 0
        """
        # Store function signature for future reference
        self.function_signatures[function_name] = {
            'num_locals': num_locals
        }
        
        instructions = [
            f"{function_name}:",  # Function label
        ]
        
        # Initialize local variables to zero
        for _ in range(int(num_locals)):
            instructions.extend([
                "MOV R0, #0",
                f"STR R0, [{self.compute_stack_ptr},#0]",
                f"ADD {self.compute_stack_ptr}, {self.compute_stack_ptr}, #4"
            ])
       
        
        return instructions
    
    
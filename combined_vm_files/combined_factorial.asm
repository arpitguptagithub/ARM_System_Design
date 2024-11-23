MOV R6, #0x100
ADD R6, R6, #120
ADD R4, R6,#64
ADD R5, R4,#0
ADD R7, R4, #0

B end_mul_label
multi:
LDR R0, [R5,#0]
LDR R1, [R5,#4]
MOV R2, #0
MOV R3, #0
CMP R0, #0
BGE temp_label_5
SUB R3, R3, #1
MOV R8, #0
SUB R8, R8, R0
ADD R0, R8,#0
temp_label_5:
CMP R1, #0
BGE temp_label_1
ADD R3, R3, #1
MOV R8, #0
SUB R8, R8, R1
ADD R1, R8,#0
temp_label_1:
CMP R0, #0
BEQ temp_label_2
ADD R2, R2, R1
SUB R0, R0, #1
B temp_label_1
temp_label_2:
CMP R3, #0
BGE temp_label_4
MOV R8, #0
SUB R8, R8, R2
ADD R2, R8,#0
temp_label_4:
ADD R0, R2,#0
STR R0, [R5,#0]
ADD R1, R5, #4
SUB R7,R4, #4
LDR R5, [R7,#0]
SUB R7, R7, #4
LDR R4, [R7,#0]
SUB R7, R7, #4
LDR R0, [R7,#0]
ADD R7, R1,#0
ADD PC, R0,#0
end_mul_label:
ADD R2,R6, #0
SUB R2, R2, #10
ADD R0, R2, #0
STR R0, [R7,#0]
ADD R7, R7, #4
ADD R2,R7, #0
SUB R2, R2, #4
LDR R0, [R2,#0]
ADD R1, R6, #0
STR R0, [R1,#0]
SUB R7, R7, #4
MOV R0, #10
STR R0, [R7,#0]
ADD R7, R7, #4
ADD R2,R7, #0
SUB R2, R2, #4
LDR R0, [R2,#0]
ADD R1, R6, #0
STR R0, [R1,#0]
SUB R7, R7, #4
B return_glob_init_0
return_glob_init_0:
ADD R2,R6, #0
SUB R2, R2, #30
ADD R0, R2, #0
STR R0, [R7,#0]
ADD R7, R7, #4
ADD R2,R7, #0
SUB R2, R2, #4
LDR R0, [R2,#0]
ADD R1, R6, #0
STR R0, [R1,#0]
SUB R7, R7, #4
MOV R0, #23
STR R0, [R7,#0]
ADD R7, R7, #4
ADD R2,R7, #0
SUB R2, R2, #4
LDR R0, [R2,#0]
ADD R1, R6, #0
STR R0, [R1,#0]
SUB R7, R7, #4
B return_glob_init_1
return_glob_init_1:
ADD R7, R7, #4
LDR R0, =temp_label_16
STR R0, [R7,#0]
ADD R7, R7, #4
STR R4, [R7,#0]
ADD R7, R7, #4
STR R5, [R7,#0]
ADD R7, R7, #4
ADD R4, R7, #0
SUB R5, R7, #16
B main
temp_label_16:
end:
B end
main:
MOV R0, #10
STR R0, [R7,#0]
ADD R7, R7, #4
ADD R7, R7, #4
LDR R0, =temp_label_17
STR R0, [R7,#0]
ADD R7, R7, #4
STR R4, [R7,#0]
ADD R7, R7, #4
STR R5, [R7,#0]
ADD R7, R7, #4
ADD R4, R7, #0
SUB R5, R7, #20
B func2
temp_label_17:
ADD R2,R7, #0
SUB R2, R2, #4
LDR R0, [R2,#0]
STR R0, [R5,#0]
ADD R1, R5, #4
SUB R7, R4, #4
LDR R5, [R7,#0]
SUB R7, R7, #4
LDR R4, [R7,#0]
SUB R7, R7, #4
LDR R0, [R7,#0]
ADD R7, R1, #0
ADD PC, R0, #0
func2:
MOV R0, #0
STR R0, [R7,#0]
ADD R7, R7, #4
ADD R0, R5, #0
LDR R1, [R0,#0]
STR R1, [R7,#0]
ADD R7, R7, #4
MOV R0, #1
STR R0, [R7,#0]
ADD R7, R7, #4
ADD R2,R7, #0
SUB R2, R2, #4
LDR R0, [R2,#0]
ADD R2,R7, #0
SUB R2, R2, #8
LDR R1, [R2,#0]
CMP R1, R0
BLT temp_label_18
MOV R0, #0
B temp_label_19
temp_label_18:
MOV R0, #1
temp_label_19:
STR R0, [R7,#0]
ADD R7, R7, #4
ADD R2,R7, #0
SUB R2, R2, #4
LDR R0, [R2,#0]
CMP R0, #1
SUB R7, R7, #4
BEQ base_case
ADD R0, R5, #0
LDR R1, [R0,#0]
STR R1, [R7,#0]
ADD R7, R7, #4
ADD R0, R5, #0
LDR R1, [R0,#0]
STR R1, [R7,#0]
ADD R7, R7, #4
MOV R0, #1
STR R0, [R7,#0]
ADD R7, R7, #4
ADD R2,R7, #0
SUB R2, R2, #4
LDR R0, [R2, #0]
ADD R2,R7, #0
SUB R2, R2, #8
LDR R1, [R2, #0]
SUB R0, R1, R0
ADD R2,R7, #0
SUB R2, R2, #8
STR R0, [R2,#0]
SUB R7, R7, #4
ADD R7, R7, #4
LDR R0, =temp_label_20
STR R0, [R7,#0]
ADD R7, R7, #4
STR R4, [R7,#0]
ADD R7, R7, #4
STR R5, [R7,#0]
ADD R7, R7, #4
ADD R4, R7, #0
SUB R5, R7, #20
B func2
temp_label_20:
ADD R7, R7, #4
LDR R0, =temp_label_21
STR R0, [R7,#0]
ADD R7, R7, #4
STR R4, [R7,#0]
ADD R7, R7, #4
STR R5, [R7,#0]
ADD R7, R7, #4
ADD R4, R7, #0
SUB R5, R7, #24
B multi
temp_label_21:
ADD R2,R7, #0
SUB R2, R2, #4
LDR R0, [R2,#0]
STR R0, [R5,#0]
ADD R1, R5, #4
SUB R7, R4, #4
LDR R5, [R7,#0]
SUB R7, R7, #4
LDR R4, [R7,#0]
SUB R7, R7, #4
LDR R0, [R7,#0]
ADD R7, R1, #0
ADD PC, R0, #0
base_case:
MOV R0, #1
STR R0, [R7,#0]
ADD R7, R7, #4
ADD R2,R7, #0
SUB R2, R2, #4
LDR R0, [R2,#0]
STR R0, [R5,#0]
ADD R1, R5, #4
SUB R7, R4, #4
LDR R5, [R7,#0]
SUB R7, R7, #4
LDR R4, [R7,#0]
SUB R7, R7, #4
LDR R0, [R7,#0]
ADD R7, R1, #0
ADD PC, R0, #0
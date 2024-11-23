MOV R6, #0x10000
ADD R4, R6,#32
MOV R5, R4
MOV R7, R4
B main
factorial:
MOV R0, #0
STR R0, [R7]
ADD R7, R7, #4
ADD R0, R5, #0
LDR R1, [R0]
STR R1, [R7]
ADD R7, R7, #4
MOV R0, #1
STR R0, [R7]
ADD R7, R7, #4
LDR R0, [R7, #-4]
LDR R1, [R7, #-8]
CMP R1, R0
BLT temp_label_1
MOV R0, #0
B temp_label_2
temp_label_1:
MOV R0, #1
temp_label_2:
STR R0, [R7], #0
ADD R7, R7, #4
LDR R0, [R7, #-4]
CMP R0, #1
SUB R7, R7, #4
BEQ base_case
ADD R0, R5, #0
LDR R1, [R0]
STR R1, [R7]
ADD R7, R7, #4
ADD R0, R5, #0
LDR R1, [R0]
STR R1, [R7]
ADD R7, R7, #4
MOV R0, #1
STR R0, [R7]
ADD R7, R7, #4
LDR R0, [R7, #-4]
LDR R1, [R7, #-8]
SUB R0, R1, R0
STR R0, [R7, #-8]
SUB R7, R7, #4
LDR R0, =temp_label_3
STR R0, [R7]
ADD R7, R7, #4
STR R4, [R7]
ADD R7, R7, #4
STR R5, [R7]
ADD R7, R7, #4
MOV R4, R7
SUB R5, R7, #16
B factorial
temp_label_3:
LDR R0, [R7, #-4]
LDR R1, [R7, #-8]
MUL R0, R1, R0
STR R0, [R7, #-8]
SUB R7, R7, #4
LDR R0, [R7, #-4]
STR R0, [R5]
ADD R1, R5, #4
SUB R7, R4, #4
LDR R5, [R7]
SUB R7, R7, #4
LDR R4, [R7]
SUB R7, R7, #4
LDR R0, [R7]
MOV R7, R1
MOV PC, R0
base_case:
MOV R0, #1
STR R0, [R7]
ADD R7, R7, #4
LDR R0, [R7, #-4]
STR R0, [R5]
ADD R1, R5, #4
SUB R7, R4, #4
LDR R5, [R7]
SUB R7, R7, #4
LDR R4, [R7]
SUB R7, R7, #4
LDR R0, [R7]
MOV R7, R1
MOV PC, R0
main:
MOV R0, #10
STR R0, [R7]
ADD R7, R7, #4
LDR R0, =temp_label_6
STR R0, [R7]
ADD R7, R7, #4
STR R4, [R7]
ADD R7, R7, #4
STR R5, [R7]
ADD R7, R7, #4
MOV R4, R7
SUB R5, R7, #16
B factorial
temp_label_6:
LDR R0, [R7, #-4]
STR R0, [R5]
ADD R1, R5, #4
SUB R7, R4, #4
LDR R5, [R7]
SUB R7, R7, #4
LDR R4, [R7]
SUB R7, R7, #4
LDR R0, [R7]
MOV R7, R1
MOV PC, R0
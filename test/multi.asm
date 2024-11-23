MOV R6, #0x10000
ADD R4, R6,#32
MOV R5, R4
MOV R7, R4
B main
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
MOV R0, R8
temp_label_5:
CMP R1, #0
BGE temp_label_1
ADD R3, R3, #1
MOV R8, #0
SUB R8, R8, R1
MOV R1, R8
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
MOV R2, R8
temp_label_4:
MOV R0, R2
STR R0, [R5]
ADD R1, R5, #4
SUB R7,R4, #4
LDR R5, [R7]
SUB R7, R7, #4
LDR R4, [R7]
SUB R7, R7, #4
LDR R0, [R7]
MOV R7, R1
MOV PC, R0
divi:
LDR R0, [R5,#0]
LDR R1, [R5,#4]
MOV R2, #0
MOV R3, #0
CMP R0, #0
BGE temp_label_6
SUB R3, R3, #1
MOV R8, #0
SUB R8, R8, R0
MOV R0, R8
temp_label_6:
CMP R1, #0
BGE temp_label_7
ADD R3, R3, #1
MOV R8, #0
SUB R8, R8, R1
MOV R1, R8
temp_label_7:
CMP R0, R1
BLT temp_label_8
SUB R0, R0, R1
ADD R2, R2, #1
B temp_label_7
temp_label_8:
CMP R3, #0
BGE temp_label_9
MOV R8, #0
SUB R8, R8, R2
MOV R2, R8
temp_label_9:
MOV R0, R2
STR R0, [R5]
ADD R1, R5, #4
SUB R7,R4, #4
LDR R5, [R7]
SUB R7, R7, #4
LDR R4, [R7]
SUB R7, R7, #4
LDR R0, [R7]
MOV R7, R1
MOV PC, R0
main:
MOV R0, #-6
STR R0, [R7]
ADD R7, R7, #4
MOV R0, #7
STR R0, [R7]
ADD R7, R7, #4
LDR R0, =temp_label_11
STR R0, [R7]
ADD R7, R7, #4
STR R4, [R7]
ADD R7, R7, #4
STR R5, [R7]
ADD R7, R7, #4
MOV R4, R7
SUB R5, R7, #20
B multi
temp_label_11:
MOV R0, #-2
STR R0, [R7]
ADD R7, R7, #4
MOV R0, #-6
STR R0, [R7]
ADD R7, R7, #4
LDR R0, =temp_label_12
STR R0, [R7]
ADD R7, R7, #4
STR R4, [R7]
ADD R7, R7, #4
STR R5, [R7]
ADD R7, R7, #4
MOV R4, R7
SUB R5, R7, #20
B multi
temp_label_12:
MOV R0, #3
STR R0, [R7]
ADD R7, R7, #4
MOV R0, #5
STR R0, [R7]
ADD R7, R7, #4
LDR R0, =temp_label_13
STR R0, [R7]
ADD R7, R7, #4
STR R4, [R7]
ADD R7, R7, #4
STR R5, [R7]
ADD R7, R7, #4
MOV R4, R7
SUB R5, R7, #20
B multi
temp_label_13:
MOV R0, #-2
STR R0, [R7]
ADD R7, R7, #4
MOV R0, #7
STR R0, [R7]
ADD R7, R7, #4
LDR R0, [R7, #-4]
LDR R1, [R7, #-8]
ADD R0, R1, R0
STR R0, [R7, #-8]
SUB R7, R7, #4
MOV R0, #7
STR R0, [R7]
ADD R7, R7, #4
MOV R0, #3
STR R0, [R7]
ADD R7, R7, #4
LDR R0, =temp_label_14
STR R0, [R7]
ADD R7, R7, #4
STR R4, [R7]
ADD R7, R7, #4
STR R5, [R7]
ADD R7, R7, #4
MOV R4, R7
SUB R5, R7, #20
B divi
temp_label_14:
MOV R0, #10
STR R0, [R7]
ADD R7, R7, #4
MOV R0, #2
STR R0, [R7]
ADD R7, R7, #4
LDR R0, =temp_label_15
STR R0, [R7]
ADD R7, R7, #4
STR R4, [R7]
ADD R7, R7, #4
STR R5, [R7]
ADD R7, R7, #4
MOV R4, R7
SUB R5, R7, #20
B divi
temp_label_15:
MOV R0, #-21
STR R0, [R7]
ADD R7, R7, #4
MOV R0, #3
STR R0, [R7]
ADD R7, R7, #4
LDR R0, =temp_label_16
STR R0, [R7]
ADD R7, R7, #4
STR R4, [R7]
ADD R7, R7, #4
STR R5, [R7]
ADD R7, R7, #4
MOV R4, R7
SUB R5, R7, #20
B divi
temp_label_16:
MOV R0, #-10
STR R0, [R7]
ADD R7, R7, #4
MOV R0, #-3
STR R0, [R7]
ADD R7, R7, #4
LDR R0, =temp_label_17
STR R0, [R7]
ADD R7, R7, #4
STR R4, [R7]
ADD R7, R7, #4
STR R5, [R7]
ADD R7, R7, #4
MOV R4, R7
SUB R5, R7, #20
B divi
temp_label_17:
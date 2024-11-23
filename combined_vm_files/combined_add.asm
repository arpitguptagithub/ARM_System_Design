MOV R6, #0x100
ADD R6, R6, #0
ADD R4, R6,#64
ADD R5, R4,#0
ADD R7, R4, #0

B return_glob_init_0
return_glob_init_0:
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
MOV R0, #0
STR R0, [R7,#0]
ADD R7, R7, #4
MOV R0, #0
STR R0, [R7,#0]
ADD R7, R7, #4
MOV R0, #0
STR R0, [R7,#0]
ADD R7, R7, #4
MOV R0, #10
STR R0, [R7,#0]
ADD R7, R7, #4
ADD R2,R7, #0
SUB R2, R2, #4
LDR R0, [R2,#0]
ADD R1, R6, #0
STR R0, [R1,#0]
SUB R7, R7, #4
ADD R0, R6, #0
LDR R1, [R0,#0]
STR R1, [R7,#0]
ADD R7, R7, #4
ADD R2,R7, #0
SUB R2, R2, #4
LDR R0, [R2,#0]
ADD R1, R4, #0
STR R0, [R1,#0]
SUB R7, R7, #4
MOV R0, #5
STR R0, [R7,#0]
ADD R7, R7, #4
ADD R2,R7, #0
SUB R2, R2, #4
LDR R0, [R2,#0]
ADD R1, R6, #4
STR R0, [R1,#0]
SUB R7, R7, #4
ADD R0, R6, #4
LDR R1, [R0,#0]
STR R1, [R7,#0]
ADD R7, R7, #4
ADD R2,R7, #0
SUB R2, R2, #4
LDR R0, [R2,#0]
ADD R1, R4, #4
STR R0, [R1,#0]
SUB R7, R7, #4
ADD R0, R4, #0
LDR R1, [R0,#0]
STR R1, [R7,#0]
ADD R7, R7, #4
ADD R0, R4, #4
LDR R1, [R0,#0]
STR R1, [R7,#0]
ADD R7, R7, #4
ADD R2,R7, #0
SUB R2, R2, #4
LDR R0, [R2 , #0]
ADD R2,R7, #0
SUB R2, R2, #8
LDR R1, [R2 , #0]
ADD R0, R1, R0
ADD R2,R7, #0
SUB R2, R2, #8
STR R0, [R2,#0]
SUB R7, R7, #4
ADD R2,R7, #0
SUB R2, R2, #4
LDR R0, [R2,#0]
ADD R1, R6, #8
STR R0, [R1,#0]
SUB R7, R7, #4
ADD R0, R6, #8
LDR R1, [R0,#0]
STR R1, [R7,#0]
ADD R7, R7, #4
ADD R2,R7, #0
SUB R2, R2, #4
LDR R0, [R2,#0]
ADD R1, R4, #8
STR R0, [R1,#0]
SUB R7, R7, #4
MOV R0, #0
STR R0, [R7,#0]
ADD R7, R7, #4
ADD R2,R7, #0
SUB R2, R2, #4
LDR R0, [R2,#0]
ADD R1, R6, #8
STR R0, [R1,#0]
SUB R7, R7, #4
ADD R0, R6, #8
LDR R1, [R0,#0]
STR R1, [R7,#0]
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
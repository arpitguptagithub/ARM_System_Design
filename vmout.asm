LDR R1, Value1
LDR R2, Value2
CMP R1, R2  ; Compare them
BHI Done    ; if R1 contains highest
MOV R1, R2  ; otherwise overwrite R1
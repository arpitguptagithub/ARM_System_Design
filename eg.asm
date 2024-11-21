start:
    MOV R0, #1
    MOV R1, #10
    MOV R2, #1

loop:
    STR R2, [R0], #1
    ADD R2, R2, #1
    CMP R2, #6
    BLE continue
    MOV R2, #1

continue:
    CMP R0, R1
    BLT loop

halt:
    B halt

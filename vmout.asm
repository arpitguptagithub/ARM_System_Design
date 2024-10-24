start:
    MOV R0, #0xA
    ADD R3, R2,#0xA
loop1:
    ADDS R3, R2, R2
    MVN R9, R6
loop2:
    EOR R10, R4, R5
endloop:
    ADC R4, R0, R0
    SBC    R6 ,R0,R0,LSR #0xA
    LDR    R11,[R0],#0xA
    BLT #-13
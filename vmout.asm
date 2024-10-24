start:
    MOV R0, #20
    ADD R3, R2, R2
loop1:
    ADDS R3, R2, R2
    MVN R9, R6
loop2:
    EOR R10, R4, R5
endloop:
    ADC R4, R0, R0
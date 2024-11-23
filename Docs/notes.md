# VM translator from VM code to ARMv7 assembly code

## VM code Specification
- Stack based architecture


## VM Architecture
(To be filled)

## ARMv7 Instructions supported by the processor team

| Instruction | Description | Example |
|-------------|-------------|---------|
| MOV         | Moves an immediate value into a register | `MOV R0, #20` |
| ADD         | Adds values in two registers and stores the result | `ADD R3, R2, R2` |
| ADDS        | Adds values in two registers with status update | `ADDS R3, R2, R2` |
| ADC         | Adds with carry, taking into account the carry flag | `ADC R4, R0, R0` |
| SUB         | Subtracts values in two registers | `SUB R5, R4, R4, LSL #2` |
| SBC         | Subtracts with borrow, considering the carry flag | `SBC R6, R0, R0, LSR #1` |
| ORR         | Bitwise OR between two registers | `ORR R7, R5, R2, ASR #2` |
| AND         | Bitwise AND between two registers | `AND R8, R7, R3` |
| MVN         | Moves the bitwise negation of a register value | `MVN R9, R6` |
| EOR         | Bitwise XOR between two registers | `EOR R10, R4, R5` |
| CMP         | Compares two registers by subtracting (sets flags) | `CMP R8, R6` |
| ADDNE       | Adds registers conditionally if flags indicate not equal | `ADDNE R1, R1, R1` |
| TST         | Tests bits by performing AND (sets flags) | `TST R9, R8` |
| ADDEQ       | Adds registers conditionally if equal (sets flags) | `ADDEQ R2, R2, R2` |
| STR         | Stores a register value into memory | `STR R1, [R0], #0` |
| LDR         | Loads a value from memory into a register | `LDR R11, [R0], #0` |
| STRGT       | Conditionally stores if greater than | `STRGT R6, [R4], #0` |
| BLT         | Branches to a label if less than | `BLT #-9` |
| B           | Unconditional branch to label | `B #-1` |

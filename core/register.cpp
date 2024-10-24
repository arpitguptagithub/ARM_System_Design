/**
 * Register: Regiter stores the value of all risc-v registers.
 * 
 * Our implementation of register can support interrupt and exception (not implemented yet).
*/
// General purpose registers
int R0; // x0
int R1; // x1
int R2; // x2
int R3; // x3
int R4; // x4
int R5; // x5
int R6; // x6
int R7; // x7
int R8; // x8
int R9; // x9
int R10; // x10
int R11; // x11
int R12; // x12
int R13; // x13
int R14; // x14
int R15; // x15
int R16; // x16
int R17; // x17
int R18; // x18
int R19; // x19
int R20; // x20
int R21; // x21
int R22; // x22
int R23; // x23
int R24; // x24
int R25; // x25
int R26; // x26
int R27; // x27
int R28; // x28
int R29; // x29
int R30; // x30
int R31; // x31

// Special purpose registers
int PC; // Program counter
int SP; // Stack pointer
int GP; // Global pointer: points to the start of the heap
int FP; // Frame pointer: points to the start of the stack
int RA; // Return address

// Control and status registers
int MSTATUS; // Machine status register
int MISA; // Machine ISA register
int MEDELEG; // Machine exception delegation register
int MIDELEG; // Machine interrupt delegation register
int MIE; // Machine interrupt-enable register
int MTVEC; // Machine trap-handler base address
int MSCRATCH; // Scratch register for machine trap handlers
int MEPC; // Machine exception program counter
int MCAUSE; // Machine trap cause
int MTVAL; // Machine bad address or instruction
int MIP; // Machine interrupt pending

// Machine trap cause values
#define CAUSE_MISALIGNED_FETCH 0x0 // Instruction address misaligned
#define CAUSE_FETCH_ACCESS 0x1 // Instruction access fault
#define CAUSE_ILLEGAL_INSTRUCTION 0x2 // Illegal instruction
#define CAUSE_LOAD_ACCESS 0x3
#define CAUSE_STORE_ACCESS 0x4
#define CAUSE_USER_ECALL 0x5 // Environment call from U-mode
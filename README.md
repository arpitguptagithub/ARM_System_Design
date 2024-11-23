# VM Linker and Translator

## Overview
The VM Linker and Translator is a tool that translates VM code to ARMv7 assembly code. It consists of two main components:

### VM Linker
- Links multiple VM code files together
- Handles global initialization
- Manages symbol tables for variables and functions
- Resolves function calls between files

### VM Translator 
- Translates VM code to ARMv7 assembly
- Implements stack-based memory architecture
- Supports arithmetic, memory access, branching and function commands
- Maps VM segments to processor registers

## Memory Architecture
- Stack-based implementation
- Memory segments: VMStack, VMLocal, VMArgument, VMTemp, Static
- Register-based memory access for efficiency

## Supported Instructions
- Arithmetic operations (add, sub, mul, div, and, or, not)
- Memory access (push, pop, wmem, rmem)
- Control flow (label, goto, if-goto)
- Function calls (function, call, return)

## Contributors

### Manoj 
- Designed VM translator architecture and memory space
- Implemented core VM translator functionality
- Testing and debugging

### Nandha
- Implemented VM linker and translator components
- Designed VM linker architecture
- Testing and debugging

### Tharun
- Optimization and performance improvements
- Issue tracking and resolution
- Coordination with processor team

# Usage
```
python linker/VMLinker.py <vmcode1> <vmcode2> ... # save the output to a file in linker folder
python translator/VMTranslator.py <vmcode> # save the output to a file in src file folder
```	

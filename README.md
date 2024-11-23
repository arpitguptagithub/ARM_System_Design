# Compiler for a ppc Language and TAC-to-VM Conversion

## Overview

This repository contains the essential components and modules that were used for the development and testing of our OS:

- Final : Contains the final OS codes that were supposed to go with the built pipeline.
- Core : Contains the details of the memory layout tryouts used for Submission 1
- Drivers : Drivers written in C++ and run on local machines to ensure the correctnes of the programs
- temp : Contains the files used for testing and research on Interrupt and Process switching mechanicam (failed modules).

## File Details

### Final

#### Libraries
- Contains the essential libraries like Keyboard, Memory, Shell and Display that are being used in our OS.

#### Test
- Simple programs written in the PPC language that are present as processes on our system.
- Include programs like Fibonacci, Sorting etc..

#### testing_display
- For the Visualization of the Memory layout using python scripts.

## Contributions 

CS21B051 VSKSS Narayana Rao : 
- Designed and fully implemented high-level Keyboard and Display drivers including simulators and custom fontmaps
- Collaborated with system integration team on connecting drivers

CS21B030 Vidhyabhushan M : 
- Designed the memory layout and the shell for the OS
- Implemented Syscalls and high level modules for the process and memory management
- research and trials for PCB and interrupt mechanism

CS21B051 Prasanth M :
- Worked on Keyboard Driver.
